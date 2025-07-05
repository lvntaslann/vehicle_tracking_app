const express = require("express");
const admin = require("firebase-admin");
const db = admin.firestore();
const verifyTokenAndGetUserId = require("../utils/verifyToken");

const router = express.Router();

// Randevu ekle - transaction ile çakışma kontrolü
router.post("/:vehicleId/add_appointments", async (req, res) => {
  const userId = await verifyTokenAndGetUserId(req, res);
  if (!userId) return;

  const { vehicleId } = req.params;
  const { title, date } = req.body;

  if (!title || !date) {
    return res.status(400).json({ error: "Başlık ve tarih zorunlu" });
  }

  try {
    const appointmentDate = new Date(date);

    const appointmentCollection = db
      .collection("vehicles")
      .doc(userId)
      .collection("userVehicles")
      .doc(vehicleId)
      .collection("appointments");

    await db.runTransaction(async (transaction) => {
      const snapshot = await transaction.get(
        appointmentCollection.where("date", "==", admin.firestore.Timestamp.fromDate(appointmentDate))
      );

      if (!snapshot.empty) {
        // Aynı tarih ve saatte randevu varsa hata fırlat
        throw new Error("Bu saat için zaten bir randevu mevcut.");
      }

      const newRef = appointmentCollection.doc();
      transaction.set(newRef, {
        title,
        date: admin.firestore.Timestamp.fromDate(appointmentDate),
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    });

    return res.status(201).json({ message: "Randevu eklendi" });
  } catch (err) {
    // Çakışma hatasıysa 409 Conflict dön
    if (err.message === "Bu saat için zaten bir randevu mevcut.") {
      return res.status(409).json({ error: err.message });
    }
    // Diğer tüm hatalar için 500 Internal Server Error
    return res.status(500).json({ error: "Randevu ekleme başarısız" });
  }
});

// Randevuları listele
router.get("/:vehicleId/get_appointments", async (req, res) => {
  const userId = await verifyTokenAndGetUserId(req, res);
  if (!userId) return;

  const { vehicleId } = req.params;

  try {
    const snapshot = await db
      .collection("vehicles")
      .doc(userId)
      .collection("userVehicles")
      .doc(vehicleId)
      .collection("appointments")
      .orderBy("date", "desc")
      .get();

    const appointments = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
      date: doc.data().date.toDate(),
    }));

    return res.status(200).json({ appointments });
  } catch (err) {
    return res.status(500).json({ error: err.message });
  }
});

module.exports = router;
