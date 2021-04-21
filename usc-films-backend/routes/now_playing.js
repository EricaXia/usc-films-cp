const express = require("express");
const axios = require("axios");

// Its more modular to use router to route to the main app.js
let router = express.Router();

const API_KEY = "a0f44b5888d8f94e608f47c1eb5575a4";

const url1 =
    "https://api.themoviedb.org/3/movie/now_playing?api_key=" +
    API_KEY +
    "&language=en-US&page=1";

router.get("/", (req, res) => {
    axios
        .get(url1)
        .then((resp) => {
            const now_playing = resp.data["results"]
                .slice(0, 5)
                .map(({ id, title, release_date, poster_path }) => ({ id, title, release_date, poster_path }));

            for (var i = 0; i < now_playing.length; i++) {
                now_playing[i]["media_type"] = "movie";

                if (now_playing[i]['release_date']) {
                    now_playing[i]['year'] = now_playing[i]['release_date'].split("-")[0];
                }
            }

            res.json({
                results: now_playing
            })

        })
        .catch((error) => console.log(error));
});

module.exports = router;