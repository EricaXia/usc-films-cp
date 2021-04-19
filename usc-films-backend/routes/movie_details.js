/* Details page code */
const express = require("express");
const axios = require("axios");
let movieDetailsRouter = express.Router({ mergeParams: true });

const API_KEY = "a0f44b5888d8f94e608f47c1eb5575a4";

/* Send data to details page*/
movieDetailsRouter.get("/", (req, res) => {
  const movie_id = req.params.movie_id;

  const details_url =
    "https://api.themoviedb.org/3/movie/" +
    movie_id +
    "?api_key=" +
    API_KEY +
    "&language=en-US&";
  let details = axios.get(details_url);

  const video_url =
    "https://api.themoviedb.org/3/movie/" +
    movie_id +
    "/videos?api_key=" +
    API_KEY +
    "&language=en-US";
  let video = axios.get(video_url);

  const cast_url =
    "https://api.themoviedb.org/3/movie/" +
    movie_id +
    "/credits?api_key=" +
    API_KEY +
    "&language=en-US";
  let cast = axios.get(cast_url);

  const reviews_url =
    "https://api.themoviedb.org/3/movie/" +
    movie_id +
    "/reviews?api_key=" +
    API_KEY +
    "&language=en-US&page=1";
  let reviews = axios.get(reviews_url);

  const recs_url =
    "https://api.themoviedb.org/3/movie/" +
    movie_id +
    "/recommendations?api_key=" +
    API_KEY +
    "&language=en-US&page=1";
  let recs = axios.get(recs_url);

  const options = {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  };



  axios
    .all([details, video, cast, reviews, recs])
    .then(
      axios.spread((...responses) => {

        const details2 = responses[0].data;

        details2["year"] = details2["release_date"].split("-")[0];
        details2["star_rating"] = details2["vote_average"] / 2;

        const genres_list = []
        if (details2["genres"].length > 0) {
          for (var i = 0; i < details2["genres"].length; i++) {
            genres_list.push(details2["genres"][i]["name"])
          }
        }
        details2["genres_str"] = genres_list.join(", ");

        const video2 = responses[1].data;

        if (video2["results"].length > 0) {
          console.log("videos available");
          details2["video_id"] = video2["results"][0]["key"]
        } else {
          details2["video_id"] = null
        }

        const cast2 = responses[2].data.cast;
        details2["cast"] = cast2.slice(0, 10);
        // let cast3 = [];
        // for (var i = 0; i < cast2.length; i++) {
        //   if (cast2[i]["profile_path"]) {
        //     cast2[i]["img_path"] = "https://image.tmdb.org/t/p/w500" + cast2[i]["profile_path"];
        //     cast3.push({
        //       "img_path": cast2[i]["img_path"],
        //       "name": cast2[i]["name"],
        //       "id": cast2[i]["id"]
        //     });
        //   }
        // }

        const reviews2 = responses[3].data.results;

        for (let i = 0; i < reviews2.length; i++) {
          let review_date = new Date(reviews2[i]["created_at"]);
          reviews2[i]["review_date"] = new Intl.DateTimeFormat('en-us', options).format(review_date);

          reviews2[i]["star_rating"] = reviews2[i]["author_details"]["rating"] / 2
        }
        details2["reviews"] = reviews2.slice(0, 3);

        const recs2 = responses[4].data;
        details2["recs"] = recs2;

        res.json({
          results: [details2]
        });
      })
    )
    .catch((error) => console.log(error));
});

module.exports = movieDetailsRouter;
