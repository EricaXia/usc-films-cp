const express = require("express");
const axios = require("axios");

// Its more modular to use router to route to the main app.js
let router = express.Router();

const API_KEY = "a0f44b5888d8f94e608f47c1eb5575a4";

const url1 =
    "https://api.themoviedb.org/3/tv/airing_today?api_key=" +
    API_KEY +
    "&language=en-US&page=1";

router.get("/", (req, res) => {
    axios
        .get(url1)
        .then((resp) => {
            const airing_today = resp.data["results"]
                .slice(0, 5)
                .map(({ id, name, first_air_date, poster_path }) => ({ id, name, first_air_date, poster_path }));

            for (var i = 0; i < airing_today.length; i++) {
                if (airing_today[i]['first_air_date']) {
                    airing_today[i]['year'] = airing_today[i]['first_air_date'].split("-")[0];
                }
                if (airing_today[i]['name']) {
                    airing_today[i]['title'] = airing_today[i]['name']
                }
            }

            res.json({
                results: airing_today
            })

        })
        .catch((error) => console.log(error));
});

module.exports = router;