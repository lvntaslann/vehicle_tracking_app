const express = require("express");
const fetch = (...args) =>
  import("node-fetch").then(({ default: fetch }) => fetch(...args));
const admin = require("firebase-admin");
const db = admin.firestore();

const router = express.Router();
const FIREBASE_API_KEY = "firebase_api_key";

// Register - kullanıcı kaydı ve Users koleksiyonuna ekleme
router.post("/register", async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ error: "Email ve şifre gerekli." });
  }

  try {
    const userRecord = await admin.auth().createUser({ email, password });

    const userDoc = await db.collection("Users").doc(userRecord.uid).get();
    if (!userDoc.exists) {
      await db.collection("Users").doc(userRecord.uid).set({
        email: userRecord.email,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
    }

    return res.status(201).json({
      message: "Kayıt başarılı",
      uid: userRecord.uid,
      email: userRecord.email,
    });
  } catch (error) {
    return res.status(400).json({ error: error.message });
  }
});

// Login endpoint
router.post("/login", async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ error: "Email ve şifre gerekli." });
  }

  try {
    const response = await fetch(
      `https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${FIREBASE_API_KEY}`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ email, password, returnSecureToken: true }),
      }
    );

    const data = await response.json();

    if (!response.ok) {
      return res.status(401).json({ error: data.error.message });
    }

    return res.status(200).json({
      message: "Giriş başarılı",
      idToken: data.idToken,
      refreshToken: data.refreshToken,
      uid: data.localId,
      email: data.email,
    });
  } catch (error) {
    return res
      .status(500)
      .json({ error: "Giriş başarısız", details: error.message });
  }
});

module.exports = router;