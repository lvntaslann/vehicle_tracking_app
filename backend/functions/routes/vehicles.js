const express = require("express");
const admin = require("firebase-admin");
const db = admin.firestore();
const verifyTokenAndGetUserId = require("../utils/verifyToken");

const router = express.Router();

// Araç ekleme
router.post("/addVehicle", async (req, res) => {
  const userId = await verifyTokenAndGetUserId(req, res);
  if (!userId) return;

  const { plate, brand, model, year, km } = req.body;

  if (!plate || !brand || !model || !year || !km) {
    return res.status(400).json({ error: "Eksik bilgi var" });
  }

  try {
    const userDoc = await db.collection("Users").doc(userId).get();
    if (!userDoc.exists) {
      await db.collection("Users").doc(userId).set({
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    }

    const vehicleRef = await db
      .collection("vehicles")
      .doc(userId)
      .collection("userVehicles")
      .add({
        plate,
        brand,
        model,
        year,
        km,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });

    res.status(201).json({ message: "Araç eklendi", vehicleId: vehicleRef.id });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Araçları listele
router.get("/get_vehicles", async (req, res) => {
  const userId = await verifyTokenAndGetUserId(req, res);
  if (!userId) return;

  try {
    const snapshot = await db
      .collection("vehicles")
      .doc(userId)
      .collection("userVehicles")
      .orderBy("createdAt", "desc")
      .get();

    const vehicles = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));

    res.status(200).json({ vehicles });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Araç silme
router.delete("/delete_vehicle/:vehicleId", async (req, res) => {
  const userId = await verifyTokenAndGetUserId(req, res);
  if (!userId) return;

  const { vehicleId } = req.params;
  if (!vehicleId) {
    return res.status(400).json({ error: "Vehicle ID gerekli" });
  }

  try {
    await db
      .collection("vehicles")
      .doc(userId)
      .collection("userVehicles")
      .doc(vehicleId)
      .delete();

    res.status(200).json({ message: "Araç silindi" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Araç güncelleme
router.put("/update_vehicle/:vehicleId", async (req, res) => {
  const userId = await verifyTokenAndGetUserId(req, res);
  if (!userId) return;

  const { vehicleId } = req.params;
  if (!vehicleId) {
    return res.status(400).json({ error: "Vehicle ID gerekli" });
  }

  const updateData = {};
  const allowedFields = ["plate", "brand", "model", "year", "km"];

  allowedFields.forEach(field => {
    if (req.body[field] !== undefined && req.body[field] !== null && req.body[field] !== "") {
      updateData[field] = req.body[field];
    }
  });

  if (Object.keys(updateData).length === 0) {
    return res.status(400).json({ error: "Güncellenecek veri bulunamadı" });
  }

  updateData.updatedAt = admin.firestore.FieldValue.serverTimestamp();

  try {
    await db
      .collection("vehicles")
      .doc(userId)
      .collection("userVehicles")
      .doc(vehicleId)
      .update(updateData);

    res.status(200).json({ message: "Araç güncellendi" });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});


module.exports = router;