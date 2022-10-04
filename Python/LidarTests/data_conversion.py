# library import statements #
import os, sys, subprocess
from subprocess import CalledProcessError, Popen, PIPE, STDOUT
import multiprocessing as mp
import analyse_lidar

def total_num_files(input_dir):  # Gets the number of laz files in an input directory
    files = os.listdir(input_dir)
    file_names = []
    for f in files:
        if f.endswith(".laz"):  # Only count file names that end with .laz
            file_names.append(f)
    return file_names

def find_las_files(input_dir):  # Finds all las files in an input directory and returns them in a list
    files = os.listdir(input_dir)
    file_names = []
    for f in files:
        if f.endswith(".las"):  # Only select file names that end with .las
            file_names.append(f)
    return file_names

def find_laz_files(input_dir, processed_files, max_num=1):  # Finds a specific number of laz files in an input directory
    files = os.listdir(input_dir)
    file_names = []
    for f in files:
        if f.endswith(
                ".laz") and f not in processed_files:  # Only select file names that end with .laz and have not already been selected
            if len(file_names) < max_num:
                file_names.append(f)
            else:
                break
    return file_names

def parallelize_zip(in_files_list):  # Converts laz to las using the laszip tool in LAStools

    Tile_name = os.path.join(analyse_lidar.config.raw_data_directory, in_files_list)  # Creates the full path name  of the .laz tile of interest
    LAZ_tile_name = in_files_list
    output_las_file = analyse_lidar.config.las_data_directory + LAZ_tile_name.replace(".laz", ".las")  # Creates the output file ending with .las
    print("Processing LAZ to LAS for {}".format(LAZ_tile_name))
    args = [analyse_lidar.config.laszip_path, Tile_name, "-o", output_las_file]  # Execute laszip tool
    proc = subprocess.Popen(args, shell=False)
    proc.communicate()  # Wait for las zip to finish executing
    return output_las_file

def convert_to_las():

    analyse_lidar.config.toolbox.set_verbose_mode(True)  # Sets verbose mode. If verbose mode is False, tools will not print output messages
    input_LAZ_dir = "C:\\Path\\to\\input\\LAZ\\directory\\"  # Input LAZ file directory; change this based on your computer environment
    out_las_file_dir = "C:\\Path\\to\\las\\output\\directory\\"  # Output LAS directory; change this based on your computer environment
    out_zlidar_file_dir = "C:\\Path\\to\\zlidar\\output\\directory\\"  # Output zlidar directory; change this based on your computer environment

    if os.path.isdir(out_las_file_dir) != True:  # Creates the las output directory if it does not already exist
        os.mkdir(out_las_file_dir)

    if os.path.isdir(out_zlidar_file_dir) != True:  # Creates the zlidar output directory if it does not already exist
        os.mkdir(out_zlidar_file_dir)

    #####################
    # Set up parameters #
    #####################
    num_batch_file = 8  # Number of laz files to be used at a time: change this to how many files you want per batch (make sure it is less than or equal to the total number of .las files to be converted)
    pool = mp.Pool(mp.cpu_count())  # Multi-threaded command, counts number of cores user's CPU has

    # Start of processing
    processed_files = []
    total_files = total_num_files(input_LAZ_dir)  # Gets the total number of files
    flag = True  # flag argument, this block of code will execute as long as true
    while flag:
        laz_file_names = find_laz_files(input_LAZ_dir, processed_files,
                                        num_batch_file)  # Call function to get laz files
        if len(laz_file_names) >= 1:  # Has to be zero or less than/equal to 1 in order to account for when only 1 file left
            in_list = ""
            for i in range(len(laz_file_names)):  # Go through files in directory to be used as the input files
                if i < len(laz_file_names) - 1:
                    in_list += f"{laz_file_names[i]};"
                else:
                    in_list += f"{laz_file_names[i]}"
                processed_files.append(laz_file_names[i])

            pool.map(parallelize_zip, laz_file_names)  # Calls the parallelizing function on .LAZ to convert to .LAS
            print("Number of completed files {} of {}\n".format(len(processed_files), len(total_files)))

            # Convert LAS to zlidar
            wbt.set_working_dir(out_las_file_dir)  # Set working dir to location of .LAS files needed to be converted
            print("Converting LAS to zLidar")
            wbt.las_to_zlidar(
                outdir=out_zlidar_file_dir)  # Calls the WBT tool las_to_zlidar to convert .LAS files to .zlidar files

            # Delete LAS
            delete_files = find_las_files(
                out_las_file_dir)  # Gets names of .LAS files in the .LAS directory and deletes them to decrease redundancy
            for a in range(len(delete_files)):
                os.remove(os.path.join(out_las_file_dir, delete_files[a]))
                print("Deleting LAS files {} of {}".format(a + 1, len(delete_files)))

        else:
            flag = False


if __name__ == "__main__":
    main()
    print("script complete")

