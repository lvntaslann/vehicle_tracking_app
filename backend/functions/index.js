const functions = require("firebase-functions");
const admin = require("firebase-admin");
const express = require("express");
const cors = require("cors");

admin.initializeApp();

const app = express();
app.use(cors({ origin: true }));
app.use(express.json());

// Routerları import et
const authRoutes = require("./routes/auth");
const vehicleRoutes = require("./routes/vehicles");
const serviceRecordRoutes = require("./routes/serviceRecords");
const appointmentRoutes = require("./routes/appointments");

app.use("/auth", authRoutes);
app.use("/vehicles", vehicleRoutes);
app.use("/vehicles", appointmentRoutes);
app.use("/vehicles", serviceRecordRoutes);

app.get("/test", (req, res) => {
  res.send("API çalışıyor");
});

exports.api = functions.https.onRequest(app);
