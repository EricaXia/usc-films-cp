/* Details page code */
const express = require("express");
const axios = require("axios");
let castDetailsRouter = express.Router({ mergeParams: true });

const API_KEY = "a0f44b5888d8f94e608f47c1eb5575a4";

/* Send data to details page*/
castDetailsRouter.get("/", (req, res) => {
    const cast_id = req.params.cast_id;

    const cast_url = "https://api.themoviedb.org/3/person/" + cast_id + " ?api_key=" + API_KEY + "&language=en-US";

    let cast_details = axios.get(cast_url);

    const cast_ext_url = "https://api.themoviedb.org/3/person/" + cast_id + "/external_ids?api_key=" + API_KEY + "&language=en-US";

    let cast_ext_details = axios.get(cast_ext_url);

    const options = {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: '2-digit',
        minute: 'numeric',
        second: 'numeric',
        hour12: true
    };


    axios
        .all([cast_details, cast_ext_details])  //
        .then(
            axios.spread((...responses) => {
                const cast = [responses[0].data].map(
                    ({ id, name, birthday, place_of_birth, profile_path, gender, known_for_department, also_known_as, biography }) => ({ id, name, birthday, place_of_birth, profile_path, gender, known_for_department, also_known_as, biography }));

                if (cast[0]["profile_path"]) {
                    cast[0]["img_path"] = "https://image.tmdb.org/t/p/w500" + cast[0]["profile_path"];
                }
                if (cast[0]["gender"] === 1) {
                    cast[0]["gender_str"] = "Female"
                } else {
                    cast[0]["gender_str"] = "Male"
                }
                const cast2 = cast[0];

                const cast_ext = [responses[1].data].map(({ imdb_id, facebook_id, instagram_id, twitter_id }) => ({ imdb_id, facebook_id, instagram_id, twitter_id }));

                // console.log(cast_ext);

                cast2["external_ids"] = cast_ext[0];




                // Send everything in one json to the client
                res.json({
                    cast: cast2,
                });
            })
        )
        .catch((error) => console.log(error));
});

module.exports = castDetailsRouter;
