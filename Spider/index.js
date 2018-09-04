const request = require('superagent');
const cheerio = require('cheerio');
const fs = require('fs');
const url = require('url');

for (var i = 0; i < 18; i++) {

  request
    .get('https://movie.douban.com/celebrity/1018990/photos/?=0')
    .query({ start: i*30 }) // query string
    .end((err, res) => {
      // Do something
      const $ = cheerio.load(res.text);
      $('div.article li img').each(function(i, elem) {

        const imgSrc = $(this).attr("src");

        const loc = url.parse(imgSrc).pathname.split("/")[5];

        var stream = fs.createWriteStream('download/'+loc);
        var req = request.get(imgSrc);
        req.pipe(stream);

      });
    });
}
