import os
import shutil
import uuid
import ffmpeg

# Dependencies:
# sudo apt install ffmpeg
# pip install python-ffmpeg

def is_video(file_path):
    try:
        # ffmpeg.input(file_path).output(os.devnull, format='null').run(capture_stdout=True, capture_stderr=True)
        # ffmpeg.input(file_path).output('-', format='null').run(overwrite_output=True) => errors are thrown
        ffmpeg.input(file_path).output('dummy_output', format='null').run(capture_stdout=True, capture_stderr=True)
        return True
    except ffmpeg.Error:
        return False

def move_videos(source_folders, destination_folder):
    if not os.path.exists(destination_folder):
        os.makedirs(destination_folder)

    video_extensions = ['.mp4', '.mov', '.avi', '.mkv', '.wmv', '.webm']

    for source_folder in source_folders:
        for root, dirs, files in os.walk(source_folder):
            for file in files:
                if any(file.lower().endswith(ext) for ext in video_extensions):
                    source_path = os.path.join(root, file)

                    if is_video(source_path):
                        unique_identifier = str(uuid.uuid4())[:8]
                        new_filename = f"{os.path.splitext(file)[0]}_{unique_identifier}{os.path.splitext(file)[1]}"
                        
                        destination_path = os.path.join(destination_folder, new_filename)

                        shutil.move(source_path, destination_path)
                        print(f'Moved: {file} to {destination_path}')
                    else:
                        print(f'Error: {file} is a corrupted video.')
                else:
                    print(f'Error: {file} is not a valid video format.')

source_folders = ['Videos']
destination_folder = 'VideosThatCanBeOpened'

move_videos(source_folders, destination_folder)
