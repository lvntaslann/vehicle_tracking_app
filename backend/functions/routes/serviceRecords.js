const express = require("express");
const admin = require("firebase-admin");
const db = admin.firestore();
const verifyTokenAndGetUserId = require("../utils/verifyToken");

const router = express.Router();

// Servis kaydı ekle (sadece açıklama ve tarih)
router.post("/:vehicleId/serviceRecords", async (req, res) => {
  const userId = await verifyTokenAndGetUserId(req, res);
  if (!userId) return;

  const { vehicleId } = req.params;
  const { description, date } = req.body;

  if (!description || !date) {
    return res.status(400).json({ error: "Eksik bilgi var" });
  }

  try {
    const ref = await db
      .collection("vehicles")
      .doc(userId)
      .collection("userVehicles")
      .doc(vehicleId)
      .collection("serviceRecords")
      .add({
        description,
        date: admin.firestore.Timestamp.fromDate(new Date(date)),
      });

    res.status(201).json({ message: "Servis kaydı eklendi", recordId: ref.id });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Servis kayıtlarını listele (isteğe bağlı, eğer kullanıyorsan)
router.get("/:vehicleId/serviceRecords", async (req, res) => {
  const userId = await verifyTokenAndGetUserId(req, res);
  if (!userId) return;

  const { vehicleId } = req.params;

  try {
    const snapshot = await db
      .collection("vehicles")
      .doc(userId)
      .collection("userVehicles")
      .doc(vehicleId)
      .collection("serviceRecords")
      .orderBy("date", "desc")
      .get();

    const records = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));

    res.status(200).json({ serviceRecords: records });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
