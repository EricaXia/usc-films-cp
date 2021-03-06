/* Search function*/
const express = require("express");
const axios = require("axios");
let searchRouter = express.Router({ mergeParams: true });

const API_KEY = "a0f44b5888d8f94e608f47c1eb5575a4";

searchRouter.get("/", (req, res) => {
    const query = req.params.query;
    const url = "https://api.themoviedb.org/3/search/multi?api_key=" + API_KEY + "&language=en-US&page=1&query=" + query;
    axios
        .get(url)
        .then((resp) => {
            let search_data = resp.data.results
            let search_data2 = [];

            for (var i = 0; i < search_data.length; i++) {
                if (search_data[i]["name"]) {
                    search_data[i]["title"] = search_data[i]["name"];
                }

                if (search_data[i]["vote_average"]) {
                    search_data[i]["star_rating"] = (search_data[i]["vote_average"] / 2).toFixed(1);
                }

                // skip results that DON"T have images
                if (search_data[i]["backdrop_path"] && search_data[i]["poster_path"]) {
                    search_data[i]["img_path"] = "https://image.tmdb.org/t/p/w500" + search_data[i]["backdrop_path"];

                    if (search_data[i]["release_date"]) {
                        search_data[i]["year"] = search_data[i]["release_date"].split("-")[0];
                    } else if (search_data[i]["first_air_date"]) {
                        search_data[i]["year"] = search_data[i]["first_air_date"].split("-")[0];
                    } else {
                        search_data[i]["year"] = "2021"
                    }

                    search_data2.push({
                        "id": search_data[i]["id"],
                        "title": search_data[i]["title"],
                        "media_type": search_data[i]["media_type"],
                        "year": search_data[i]["year"],
                        "star_rating": search_data[i]["star_rating"],
                        "poster_path": search_data[i]["poster_path"],
                        "img_path": search_data[i]["img_path"]
                        
                    });
                }

            } // end for loop

            // If returning top 10 results only
            // let search_data3 = search_data2.slice(0,10);

            res.json({
                results: search_data2
            });

        })
        .catch((error) => console.log(error));
});

module.exports = searchRouter;
