import os


def main():
    your_name = os.environ.get('NAME', 'Default_Name')
    while True:
        print(f'Hello! Your name is {your_name}.')


if __name__ == '__main__':
    main()
