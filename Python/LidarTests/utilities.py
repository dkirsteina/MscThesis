import os

def create_folder(base, folder, delete_content=False):
    folder_name = os.path.join(os.sep, base, folder)

    if not os.path.isdir(folder_name): # Creates the output directory if it does not already exist"
        os.mkdir(folder_name)

    # if folder can not exist (is temporary) then clear content
    if delete_content:
        for root, dirs, files in os.walk(folder_name):
            for file in files:
                os.remove(os.path.join(root, file))

    return folder_name