const request = require('request');

const a = "39.7456"
const b = "-97.0892"

function getCityStateTemp(lat,long) {
  const options = {
    'method': 'GET',
    'url': 'https://api.weather.gov/points/' + lat + ',' + long,
    'headers': {
      'User-Agent': '(myweatherapp.com, contact@myweatherapp.com)'
    }
  };
  
  request(options, function (error, response) {
    if (error) throw new Error(error);
    // console.log(response.body);
  
    const obj = JSON.parse(response.body);
  
    const city = obj.properties.relativeLocation.properties.city;
    console.log(city)
  
    const state = obj.properties.relativeLocation.properties.state;
    console.log(state)
  
    const tempUrl = obj.properties.forecast;
    // console.log(tempUrl)
  
    const tempOptions = {
      'method': 'GET',
      'url': tempUrl,
      'headers': {
        'User-Agent': '(myweatherapp.com, contact@myweatherapp.com)'
      }
    };
  
    const tempArray = []
  
    request(tempOptions, function (err, res) {
        if (err) throw new Error(err);
        
        const obj = JSON.parse(res.body);
  
        const temp = obj.properties.periods;
        // console.log(temp);
        
        temp.forEach((element) => {
          // console.log(element.temperature);
          tempArray.push(element.temperature);
      });
  
      console.log(tempArray[0]);
  
    });
  
  });
}

getCityStateTemp(a,b);