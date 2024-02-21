import jwt from "jsonwebtoken";

const Middleware = {

    isLoginCheck: (req, res, next) => {
        try {
            const token = req.cookies?.token || req.header("Authorization")?.replace("Bearer ", "");
            if (!token) {
                return res.status(403).json({
                    success: false,
                    message: "You are not logged in!",
                });
            }

            const decode = jwt.verify(token, process.env.JWT_SECRET);
            if (!decode) {
                return res.status(400).json({
                    success: false,
                    message: "Invalid token!",
                });
            }
            req.user = decode;
            return next();
        } catch (error) {
            console.log(error);
            return res.status(500).json({
                success: false,
                message: "Error verifying the token!",
                error,
            });
        };
    }

}

export { Middleware };