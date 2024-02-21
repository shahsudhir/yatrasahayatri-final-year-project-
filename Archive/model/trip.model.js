import mongoose from "mongoose";

const tripSchema = new mongoose.Schema(
  {
    userId:{
        type: String,
        default: "",
      },
    type:{
        type: String,
        default: "",
      },
      placeName:{
        type: String,
        default: "",
      },
      latLong:{
        type: mongoose.SchemaTypes.Mixed,
      },
      content:{
        type: mongoose.SchemaTypes.Mixed,
      },
      daysContent:{
        type: mongoose.SchemaTypes.Mixed,
      },
  },
  {
    timestamps: true,
  }
);

const TripModel = mongoose.models.Trip || mongoose.model("Trip", tripSchema);
export { TripModel };
