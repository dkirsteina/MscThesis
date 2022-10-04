import whitebox
import utilities


class Config:

    def __init__(self, base):
        self.toolbox = whitebox.WhiteboxTools()
        self.raw_data_directory = utilities.create_folder(base, 'Raw')
        self.las_data_directory = utilities.create_folder(base, 'Las')
        self.output_directory = utilities.create_folder(base, 'Output')
        self.laszip_path = "laszip.exe" # TODO should be with script

    def validate(self):
        if not self.raw_data_directory:
            raise Exception("Input data folder is missing!")
        if not self.las_data_directory:
            raise Exception("Can not create las data folder!")
        if not self.output_directory:
            raise Exception("Can not create output folder!")

