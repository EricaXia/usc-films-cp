const express = require("express");
const axios = require("axios");

// Its more modular to use router to route to the main app.js
let popularRouter = express.Router({ mergeParams: true });

const API_KEY = "a0f44b5888d8f94e608f47c1eb5575a4";

popularRouter.get("/", (req, res) => {
    const media_type = req.params.media_type;
    const url =
    "https://api.themoviedb.org/3/" + media_type + "/popular?api_key=" + API_KEY + "&language=en-US&page=1";

    axios
        .get(url)
        .then((resp) => {
            const popular = resp.data["results"]
                .slice(0, 5)
                .map(({ id, title, name, release_date, first_air_date,poster_path }) => ({ id, title, name, release_date, first_air_date, poster_path }));

            for (var i = 0; i < popular.length; i++) {
                if (popular[i]['name']) {
                    popular[i]['title'] = popular[i]['name']
                }

                if (popular[i]['release_date']) {
                    popular[i]['year'] = popular[i]['release_date'].split("-")[0];
                } 
                else if (popular[i]['first_air_date']) {
                    popular[i]['year'] = popular[i]['first_air_date'].split("-")[0];
                }
            }

            res.json({
                results: popular
            })

        })
        .catch((error) => console.log(error));
});

module.exports = popularRouter;
