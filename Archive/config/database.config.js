import mongoose from "mongoose";

export const connect = () => {
    mongoose.set("strictQuery", false);
    mongoose.connect(process.env.MONGODB_URL, {
        useNewUrlParser: true,
        useUnifiedTopology: true,
    })
    .then((conn) => {
        console.log(`🚀 🚀 🚀 🚀 Database Connected Successfully 🚀 🚀 🚀 🚀`);
        console.log(
            "---------------------------------------------------------------"
        );
    })
    .catch((error) => {
        console.log("DB Connection Failed!");
        console.log(error);
        process.exit(1);
    });
};