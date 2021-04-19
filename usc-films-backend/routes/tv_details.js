/* Details page code */
const express = require("express");
const axios = require("axios");
let tvDetailsRouter = express.Router({ mergeParams: true });

const API_KEY = "a0f44b5888d8f94e608f47c1eb5575a4";

/* Send data to details page*/
tvDetailsRouter.get("/", (req, res) => {
  const movie_id = req.params.movie_id;

  const details_url =
    "https://api.themoviedb.org/3/tv/" +
    movie_id +
    "?api_key=" +
    API_KEY +
    "&language=en-US&";
  let details = axios.get(details_url);

  const video_url =
    "https://api.themoviedb.org/3/tv/" +
    movie_id +
    "/videos?api_key=" +
    API_KEY +
    "&language=en-US";
  let video = axios.get(video_url);

  const cast_url =
    "https://api.themoviedb.org/3/tv/" +
    movie_id +
    "/credits?api_key=" +
    API_KEY +
    "&language=en-US";
  let cast = axios.get(cast_url);

  const reviews_url =
    "https://api.themoviedb.org/3/tv/" +
    movie_id +
    "/reviews?api_key=" +
    API_KEY +
    "&language=en-US&page=1";
  let reviews = axios.get(reviews_url);

  const recs_url =
    "https://api.themoviedb.org/3/tv/" +
    movie_id +
    "/recommendations?api_key=" +
    API_KEY +
    "&language=en-US&page=1";
  let recs = axios.get(recs_url);

  const sim_url =
    "https://api.themoviedb.org/3/tv/" +
    movie_id +
    "/similar?api_key=" +
    API_KEY +
    "&language=en-US&page=1";
  let sim = axios.get(sim_url);

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
    .all([details, video, cast, reviews, recs, sim])
    .then(
      axios.spread((...responses) => {
        const details2 = responses[0].data; // add ".map() method to specify which k:v pairs to get"
        if (details2['name']) {
          details2['title'] = details2['name'];
          // console.log(details2['title']);
        }

        const video2 = responses[1].data;
        // console.log(video2);

        const cast2 = responses[2].data.cast;
        let cast3 = [];

        // console.log(cast2);
        /* 
        remove the element in the array if the element['prof_path'] value is empty */
        for (var i = 0; i < cast2.length; i++) {
          if (cast2[i]["profile_path"]) {
            // console.log(cast2[i]["name"], cast2[i]["profile_path"])
            cast2[i]["img_path"] = "https://image.tmdb.org/t/p/w500" + cast2[i]["profile_path"];
            cast3.push({
              "img_path": cast2[i]["img_path"],
              "name": cast2[i]["name"],
              "character": cast2[i]["character"],
              "id": cast2[i]["id"]
            });
          }
        }

        const reviews2 = responses[3].data.results;
        // console.log(reviews2);

        for (let i = 0; i < reviews2.length; i++) {
          let review_date = new Date(reviews2[i]["created_at"]);
          reviews2[i]["review_date"] = new Intl.DateTimeFormat('en-us', options).format(review_date);

          if (!reviews2[i]["author_details"]["avatar_path"]) {
            reviews2[i]["img_path"] =
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHnPmUvFLjjmoYWAbLTEmLLIRCPpV_OgxCVA&usqp=CAU";
          } else if (
            reviews2[i]["author_details"]["avatar_path"].includes("https")
          ) {
            let path = reviews2[i]["author_details"]["avatar_path"]
              .split("/")
              .slice(1)
              .join("/");
            reviews2[i]["img_path"] = path;
          } else {
            reviews2[i]["img_path"] =
              "https://image.tmdb.org/t/p/original" +
              reviews2[i]["author_details"]["avatar_path"];
          }
        }


        const recs2 = responses[4].data;
        // console.log(recs2);

        const sim2 = responses[5].data;
        // console.log(sim2);

        // Send everything in one json to the client
        res.json({
          details: details2,
          video: video2,
          cast: cast3, //cast2
          reviews: reviews2,
          recommended: recs2,
          similar: sim2,
        });
      })
    )
    .catch((error) => console.log(error));
});

module.exports = tvDetailsRouter;
