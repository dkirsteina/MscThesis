import ntpath
from os import listdir
from os.path import isfile, join

from config import Config

# main config object
config = None

def convertLazToLas(laz_file):
    return


# main function for processing of Lidar data
def processLidarData(las_file_name, output_file_name):
    # some processing
    config.toolbox.lidar_idw_interpolation(
        i=las_file_name,
        output=output_file_name,
        parameter="elevation",
        returns="last",
        resolution=1.5,
        weight=2.0,
        radius=2.5
    )
    print(las_file_name + ' processing is done')
    return


# main function
def process_lidar_tiles(aoi, target_geometry):
    processLidarData()
    print('processLidarTiles done')
    return


def prepare_lidar_data():

    config.toolbox.set_working_dir(config.las_data_directory)
    lasfiles = [f for f in listdir(config.las_data_directory) if isfile(join(config.las_data_directory, f))]
    print("Data directory " + config.las_data_directory)
    print("Output directory " + config.output_directory)
    for lidar_file in lasfiles:
        print("Filtering of " + lidar_file + " ...")
        config.toolbox.set_verbose_mode(False)
        config.toolbox.classify_overlap_points(i=ntpath.join(config.las_data_directory, lidar_file), output=ntpath.join(config.output_directory,lidar_file), resolution=1.0, filter=True, callback=None)
        print("Done")
    return True


# utilities


# Press the green button in the gutter to run the script.
if __name__ == '__main__':

    base_directory = "C:\\projects\\Dace\\London"
    try:
        config = Config(base_directory)
        config.validate()
    except Exception as e:
        print(e)
        exit(-1)

    # print(config.toolbox.version())

    print('Processing of', base_directory, 'is started ...')

    # config.toolbox.set_verbose_mode(True)
    # config.toolbox.clip_lidar_to_polygon('C:\projects\Dace\London\Las\TQ2595_P_10768_20171207_20180124.las',
    #                                      'C:\projects\Dace\London\Testi\parks_testi.shp',
    #                                      'C:\projects\Dace\London\Testi\parks_testi.las')

    # if not prepare_lidar_data():
    #     print("Can not prepare LAS data!")
    #     exit(-1)

    # process_lidar_tiles('','')
    print('Processing is done')

# Workflow for London:

# 1) input parameters - area of interest and target geometry (optional)
# 2) get list of LAZ tiles with intersect AOI with https://environment.data.gov.uk/arcgis/rest/services/EA/SurveyIndexFiles/MapServer/13
#     other services https://environment.data.gov.uk/dataset/094d4ec8-4c21-4aa6-817f-b7e45843c5e0
# 3) download LAZ tile(es?)
# 4) extract LAZ -> LAS
# 5) join LAS in one file
# 6) clip LAS with target geometry (extract of park polygons from OSM )
# 7) process LAS data
# 8) convert processed data to output format: grid or features
