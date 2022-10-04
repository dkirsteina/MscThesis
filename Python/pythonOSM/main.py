# This is a sample Python script.
import ntpath

import fiona
from fiona.crs import from_epsg
import overpy

import requests
import json
import geopandas as gpd

# Press Shift+F10 to execute it or replace it with your code.
# Press Double Shift to search everywhere for classes, files, tool windows, actions, and settings.


def get_osm(q):
    print("Start query Overpass API ...")
    api = overpy.Overpass()
    # api.max_retry_count = 10
    # api.retry_timeout = 5.0
    # r = api.query(q)

    data = api.get(q, verbosity='geom')
    data = [f for f in data.features if f.geometry['type'] == "LineString"]
    print(data)
    print("Query is done")
    return data

def get_osm_http(output_filename, query, attr):

    print("HTTP request started")
    overpass_url = "https://overpass-api.de/api/interpreter"
    # print(overpass_query)

    response = requests.get(overpass_url, params={'data': query})
    response.raise_for_status()

    elements = response.json()["elements"]
    print("HTTP request ended")
    num_features = save_json_to_shp(output_filename, elements, attribs=attr)
    print(str(num_features) + " features are saved to " + output_filename)


    # filename = ntpath.join(folder, "pathways.json")
    # f = open(filename, 'w', encoding="utf-8")
    # json.dump(elements, f)
    # f.close()
    # print("JSON is saved")

def save_json_to_shp(file_name, data, attribs):

    wgs84 = from_epsg(4326)
    features = 0
    schema_shp = {'geometry': 'LineString', 'properties': {}}
    # create schema from attributes array
    for attrib in attribs:
        schema_shp['properties'][attrib] = 'str:80'

    with fiona.open(file_name, 'w', crs=wgs84, driver='ESRI Shapefile', schema=schema_shp) as output:
        for item in data:
            # the shapefile geometry use (lon,lat)
            line = {'type': 'LineString', 'coordinates': [(node["lon"], node["lat"]) for node in item["geometry"]]}
            props = {}
            for attrib in attribs:
                props[attrib] = 'n/a'
                if "tags" in item:
                    if attrib in item["tags"]:
                        props[attrib] = item["tags"][attrib]
            output.write({'geometry': line, 'properties': props})
            features += 1

    return features

# def save_to_shp_test(file_name):
#     schema = {'geometry': 'LineString', 'properties': {'highway': 'str:80'}}
#     wgs84 = from_epsg(4326)
#     with fiona.open(file_name, 'w', crs=4326, driver='ESRI Shapefile', schema=schema) as output:
#         line = {'type': 'LineString', 'coordinates': [(0.1, 50.), (0.2, 52.)]}
#         prop = {'highway': "n/a"}
#         output.write({'geometry': line, 'properties': prop})
#     return


def convert_json_to_shp(input, output, attributes):

    with open(input, encoding="utf8") as json_file:
        elements = json.load(json_file)["elements"]
        num_features = save_json_to_shp(output, elements, attribs=attributes)
        print(str(num_features) + " features are saved to " + output)
    return

# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    working_folder = "c:\\projects\\Dace\\London1"

    # q = """
    # [out:json];
    # area["name"="Greater London"][admin_level=5];
    # (
    #     way[highway~"^(bridleway|cycleway)$"](area);
    # );
    # out tags geom;
    # """

    # this query is for parks
    #         convert item ::=::,::geom=geom(),_osm_type=type();
    # this will convert JSON to GeoJSON
    overpass_query = """
         [out:json][timeout:60];
           area["name"="Greater London"][admin_level=5]->.search;
            (
              way[leisure="park"](area.search);
              way[leisure="garden"](area.search);
              way[landuse="cemetery"](area.search);
            );
            out tags geom;
            relation[leisure="park"](area.search)->.relations_parks;
            foreach .relations_parks -> .relation (
              (
                way(r.relation);
              );
            out tags geom;
    """

    # these are necessary fields from "tags"
    attribs = ['name','leisure','landuse','access']
    input_data = ntpath.join(working_folder, 'parks.json')
    output_data = ntpath.join(working_folder, 'parks1.shp')

    get_osm_http(output_data, overpass_query, attribs)

    # convert JSON to SHP
    #convert_json_to_shp(input_data, output_data, attribs)

