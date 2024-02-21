A SIMPLE NODE BOILERPLATE CODE

1. Uses a JWT token for authentication.
2. Uses cookies for saving token information.
3. Has user authentication.
4. Encrypt the user password while signing up using bcryptjs package.
5. Connect to MongoDB using mongoose.
6. Uses morgan as a logger.

List of dependencies

1. express
2. bcryptjs
3. jsonwebtoken
4. mongoose
5. morgan
6. cookie-parser
7. dotenv

{
$project: {
          doctorId: "$\_id",
document: "$$ROOT",
          numberOfVideos: {
            $size: "$videos",
          },
        },
      },
      { $unset: "document.videos" },
      {
        $replaceRoot: { newRoot: { $mergeObjects: ["$document", "$$ROOT"] } },
},
{ $unset: "document" },
