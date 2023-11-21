// Combine
//  capitals.geojson
//  countries.json
// Produce
//  countries_capitals.json

const fs = require('fs-extra');
// const path = require('path');

// https://github.com/Stefie/geojson-world/blob/master/capitals.geojson
// {
//   "type": "FeatureCollection",
//   "features": [{
//       "properties": {
//           "country": "Bangladesh",
//           "city": "Dhaka",
//           "tld": "bd",
//           "iso3": "BGD",
//           "iso2": "BD"
//       },
//       "geometry": {
//           "coordinates": [90.24, 23.43],
//           "type": "Point"
//       },
//       "id": "BD"
//   }, {

// ExportFlagsApp/data/countries.json
// edited from
// https://github.com/linssen/country-flag-icons/blob/master/countries.json
// [
// {
//   "url": "/wiki/Bangladesh",
//   "alpha3": "BGD",
//   "name": "Bangladesh",
//   "file_url": "//upload.wikimedia.org/wikipedia/commons/f/f9/Flag_of_Bangladesh.svg",
//   "license": "Public domain"
// },
// 23.763889, 90.388889
// <wpt lat="23.763889" lon="90.388889">

// Output
let outExample = {
  BGD: {
    url: 'https://en.wikipedia.org/wiki/Bangladesh',
    alpha3: 'BGD',
    name: 'Bangladesh',
    file_url: 'https://upload.wikimedia.org/wikipedia/commons/f/f9/Flag_of_Bangladesh.svg',
    license: 'Public domain',
    capital_city: 'Dhaka',
    latitude: 23.43,
    longitude: 90.24,
  },
};

let capitalsJSONPath = '../data/capitals.geojson';
let countriesJSONPath = '../data/countries.json';
let outputPath = '../data/countries_capitals.json';

let capitals = fs.readJsonSync(capitalsJSONPath);
let countries = fs.readJsonSync(countriesJSONPath);

let features = capitals.features;

let featuresDict = {};

for (let index = 0; index < features.length; index++) {
  let item = features[index];
  // console.log('capitals', index, item.properties.iso3, item.properties.country, item.properties.city);
  featuresDict[item.properties.iso3] = item;
}
console.log('features.length', features.length);
// features.length 241

let missingCount = 0;

let countriesDict = {};

for (let index = 0; index < countries.length; index++) {
  let item = countries[index];
  countriesDict[item.alpha3] = item;

  item.url = 'https://en.wikipedia.org' + item.url;
  item.file_url = 'https:' + item.file_url;
  item.capital_city = '';

  item.latitude = 0.0;
  item.longitude = 0.0;

  // console.log('countries', index, item.alpha3, item.name);
  let fitem = featuresDict[item.alpha3];
  if (!fitem) {
    missingCount++;
    console.log('MISSING countries', index, item.alpha3, item.name);
    continue;
  }
  item.capital_city = fitem.properties.city;
  item.latitude = fitem.geometry.coordinates[1];
  item.longitude = fitem.geometry.coordinates[0];
  // if (index > 4) break;
}
console.log('countries.length', countries.length);
console.log('MISSING countries', missingCount);

fs.writeJsonSync(outputPath, countriesDict, { spaces: 2 });

// features.length 241
// MISSING countries 1 ALA Åland Islands
// MISSING countries 26 BES Bonaire - Sint Eustatius and Saba
// MISSING countries 55 CUW Curaçao
// MISSING countries 192 SXM Sint Maarten (Dutch part)
// MISSING countries 198 SGS South Georgia and the South Sandwich Islands
// MISSING countries 199 SSD South Sudan
// MISSING countries 226 UMI United States Minor Outlying Islands
// countries.length 238
// MISSING countries 7

// let index = 0;
// let incomeNullCount = 0;
// let incomeArr = [];
// for (let ent of data.features) {
//   // console.log(index, 'ent', ent);
//   let zipcode = ent.properties.name;
//   let income = ent.properties.B19013001;
//   // console.log(index, 'zipcode', zipcode, 'income', income);
//   incomeArr.push({ zipcode, income });
//   index++;
//   if (income === null) {
//     incomeNullCount++;
//   }
// }
// let incomeHash = {};
// for (let item of incomeArr) {
//   incomeHash[item.zipcode] = item.income;
// }

// //fs.writeJsonSync(outputPath, incomeArr, { spaces: 2 });
// fs.writeJsonSync(outputPath, incomeHash, { spaces: 2 });
// //index 1786 incomeNullCount 159
// console.log('index', index, 'incomeNullCount', incomeNullCount);
