import { TripModel } from "../model/trip.model.js";

class TripController {
 create = async (req, res) => {
  try {
    let tripData=await new TripModel(req.body)
      .save()
      res.status(200).json({
        success: true,
        message: "Record ADDED",
        data: tripData,
      });
  } catch (error) {
    console.log(error);
    res.status(500).json({
      success: false,
      message: error.message || "Internal Server Error!",
      error,
    });
  }
};


 update = async (req, res) => {
  try {
    TripModel.findByIdAndUpdate(
      req.params.id,
      { $set: req.body },
      { new: true }
    )
      .then((result) => {
        if (!result) {
          return res.status(404).json({
            success: false,
            message: "Record Not Found",
          });
        }
        res.status(200).json({
          success: true,
          message: "Record Updated",
          updated_result: result,
        });
      })
      .catch((err) => {
        res.status(400).json({
          success: false,
          message: err.message,
          error: err,
        });
      });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message || "Internal Server Error!",
      error,
    });
  }
};

 remove = async (req, res) => {
  try {
    TripModel.findByIdAndDelete(req.params.id)
      .then((result) => {
        if (!result) {
          return res.status(404).json({
            success: false,
            message: "Record Not Found",
          });
        }
        res.status(200).json({
          success: true,
          message: "Record Deleted",
          data: result,
        });
      })
      .catch((err) => {
        res.status(400).json({
          success: false,
          message: err.message,
          error: err,
        });
      });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message || "Internal Server Error!",
      error,
    });
  }
};

list = async (req, res) => {
    try {
      TripModel.find({
        userId: req.user._id
      })
        .then((result) => {
          if (!result) {
            return res.status(404).json({
              success: false,
              message: "Record Not Found",
            });
          }
          res.status(200).json({
            success: true,
            message: "Record Founds",
            data: result,
          });
        })
        .catch((err) => {
          res.status(400).json({
            success: false,
            message: err.message,
            error: err,
          });
        });
    } catch (error) {
      res.status(500).json({
        success: false,
        message: error.message || "Internal Server Error!",
        error,
      });
    }
  };
}
export { TripController };
