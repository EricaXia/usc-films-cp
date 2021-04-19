/* Search function*/
const express = require("express");
const axios = require("axios");
let searchRouter = express.Router({ mergeParams: true });

const API_KEY = "a0f44b5888d8f94e608f47c1eb5575a4";

/* Send data to details page*/
searchRouter.get("/", (req, res) => {
    // const search_id = req.params.search_id;
    const query = req.params.query;
    const url = "https://api.themoviedb.org/3/search/multi?api_key=" + API_KEY + "&language=en-US&page=1&query=" + query;
    axios
        .get(url)
        .then((resp) => {
            let search_data = resp.data.results
            let search_data2 = [];

            for (var i = 0; i < search_data.length; i++) {
                if (search_data[i]['name']) {
                    search_data[i]['title'] = search_data[i]['name']
                }

                if (search_data[i]["backdrop_path"]) {
                    search_data[i]["img_path"] = "https://image.tmdb.org/t/p/w500" + search_data[i]["backdrop_path"];

                    if (search_data[i]["media_type"] === "movie") {
                        search_data[i]["weblink"] = "/watch/movie/" + search_data[i]["id"];
                    } else if (search_data[i]["media_type"] === "tv") {
                        search_data[i]["weblink"] = "/watch/tv/" + search_data[i]["id"];
                    }

                    search_data2.push({
                        "img_path": search_data[i]["img_path"],
                        "title": search_data[i]["title"],
                        "id": search_data[i]["id"],
                        "weblink": search_data[i]["weblink"]
                    });
                }

            }

            let search_data3 = search_data2.slice(0,10);

            res.send(search_data3);
        })
        .catch((error) => console.log(error));
});

module.exports = searchRouter;
