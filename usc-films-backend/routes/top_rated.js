const express = require("express");
const axios = require("axios");

// Its more modular to use router to route to the main app.js
let topRatedRouter = express.Router({ mergeParams: true });

const API_KEY = "a0f44b5888d8f94e608f47c1eb5575a4";

topRatedRouter.get("/", (req, res) => {
    const media_type = req.params.media_type;
    const url =
    "https://api.themoviedb.org/3/" + media_type + "/top_rated?api_key=" + API_KEY + "&language=en-US&page=1";

    axios
        .get(url)
        .then((resp) => {
            const top_rated = resp.data["results"]
                .slice(0, 5)
                .map(({ id, title, name, release_date, first_air_date,poster_path }) => ({ id, title, name, release_date, first_air_date, poster_path }));

            for (var i = 0; i < top_rated.length; i++) {
                if (top_rated[i]['name']) {
                    top_rated[i]['title'] = top_rated[i]['name']
                }

                if (top_rated[i]['release_date']) {
                    top_rated[i]['year'] = top_rated[i]['release_date'].split("-")[0];
                } 
                else if (top_rated[i]['first_air_date']) {
                    top_rated[i]['year'] = top_rated[i]['first_air_date'].split("-")[0];
                }
            }

            res.json({
                results: top_rated
            })

        })
        .catch((error) => console.log(error));
});

module.exports = topRatedRouter;
