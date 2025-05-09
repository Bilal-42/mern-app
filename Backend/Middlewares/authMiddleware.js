const jwt = require("jsonwebtoken");
const User = require("../models/userModel");
const asyncHandler = require("express-async-handler");

const protect = asyncHandler(async (req, res, next) => {
  let token;
  if (
    req.headers.authorization &&
    req.headers.authorization.startsWith("Bearer")
  ) {
    try {
      token = req.headers.authorization.split(" ")[1];
      const decoded = jwt.verify(token, process.env.JWT_SECRET);
      const res = await User.findById(decoded.id).select("-password");
      if (!res) {
        throw new Error("Not authorized");
      }
      req.user=res;
      next();
    } catch (error) {
      res.status(401);
      throw new Error("Not authorized!");
    }
  }
  if (!token) {
    res.status(401);
    throw new Error("Not authorized!");
  }
});

module.exports = { protect };