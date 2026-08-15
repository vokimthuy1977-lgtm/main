#define RED_BOLD "\033[1;31m"
#define RESET    "\033[0m"
#if defined(_WIN64) || defined(_WIN32)
	#include <windows.h>
	#include <locale>
#endif
#include <iostream>
#include <filesystem>
#include <string>
#include <vector>
#include <fstream>
namespace cr7spd
{
void patch_file(const std::filesystem::path *_dir_path, std::vector<std::string> *pArrayNameDollar)
{
	std::filesystem::directory_iterator _element(*_dir_path);
	std::filesystem::directory_iterator _end;
	while (_element != _end)
	{
		if (_element.operator*().is_directory() == true)
		{
			patch_file(&(_element.operator*().path()), pArrayNameDollar);
		}
		else if (_element.operator*().is_regular_file() == true)
		{
			std::string nameFile = _element.operator*().path().filename().string();
			if (nameFile[0] == '$')
			{
				std::string filenameWithoutExtension = _element.operator*().path().stem().string();
				(*pArrayNameDollar).push_back(filenameWithoutExtension);
				nameFile[0] = '_';
				std::filesystem::path newNameFile(nameFile);
				std::filesystem::path fullPathNewNameFile = _element.operator*().path().parent_path() / newNameFile;
				std::filesystem::rename(_element.operator*().path(), fullPathNewNameFile);
				std::cout << "'" << _element.operator*().path().filename().string() << "'"
						  << " đã đổi thành tên "
						  << "'" << newNameFile.string() << "'"
						  << " mới!" << std::endl;
			}
		}
		_element.operator++();
	}
}
void replaceString(std::string &_string, const std::string &_stringFind, const std::string &_stringReplace)
{
	if (_stringFind.empty()) {
		return;
	}
	unsigned long long posFind = 0;
	unsigned long long indexC;
	while (1)
	{
		indexC = _string.find(_stringFind, posFind);
		if (indexC != std::string::npos)
		{
			_string.replace(indexC, _stringFind.length(), _stringReplace);
		}
		else
		{
			break;
		}
		posFind = indexC + _stringReplace.length();
	}
}
void scanFileContent(const std::filesystem::path* _dir_path, std::vector<std::string>* pArrayNameDollar) {
	std::filesystem::directory_iterator _element(*_dir_path);
	std::filesystem::directory_iterator _end;
	while (_element != _end) {
		if (_element.operator*().is_directory() == true) {
			scanFileContent(&(_element.operator*().path()), pArrayNameDollar);
		} else if (_element.operator*().is_regular_file() == true && _element.operator*().path().extension().string() != ".tmp") {
			std::cout << "Reading and writing the file " << _element.operator*().path().filename().string() << std::endl;
			std::filesystem::path fw = _element.operator*().path();
			fw.replace_extension(".tmp");
			std::ofstream file_write(fw);
			std::ifstream file_read(_element.operator*().path());
			std::string line;
			while (getline(file_read, line)) {
				for (std::string nameDollar : *pArrayNameDollar) {
					std::string nameFix = nameDollar;
					nameFix[0] = '_';
					std::cout << RED_BOLD << "DEBUG: " << RESET << "nameDollar == " << nameDollar << ", nameFix == " << nameFix << std::endl;
					replaceString(line, nameDollar, nameFix);
				}
				file_write << line << "\n";
				std::cout << RED_BOLD << "DEBUG: " << RESET << line << std::endl;
			}
			file_write.close();
			file_read.close();
			std::filesystem::path fileOld(fw);
			std::filesystem::path fileNew = _element.operator*().path();
			std::filesystem::remove(fileNew);
			std::filesystem::rename(fileOld, fileNew);
		}
		_element.operator++();
	}
}
namespace support {
	std::string filterLongestStringVector(std::vector<std::string>* pVector) {
		if (pVector == nullptr || (*pVector).empty() == true) {
			return "";
		}
		std::string top1 = (*pVector).at(0);
		for (const std::string& element : (*pVector)) {
			if (top1.length() < element.length()) {
				top1 = element;
			}
		}
		return top1;
	}
}
} // namespace cr7spd
int main(int argc, char* argv[]) {
	#if defined(_WIN64) || defined(_WIN32)
		SetConsoleOutputCP(65001);
		std::locale::global(std::locale(""));
	#endif
	std::endl(std::operator<<(std::cout, "Welcome to Sanires. Type '--help' to learn more!\n Copyright © 2026 Truyen"));
	std::vector<std::string> arrNameDollar;
    if (argc == 1) {
        std::endl(std::operator<<(std::cout, "sanires-> No input! Type '--help' to open the lookup table!"));
    } else if (argc == 2) {
        if (strcmp(argv[1], "--directory") == 0) {
            std::endl(std::operator<<(std::cout, "sanires-> Missing argument for flag '--directory'. Use flag '--help' for help!"));
        } else if (strcmp(argv[1], "--help") == 0) {
            std::endl(std::operator<<(std::cout, "General syntax:\n sanires [options] </path/to/folder>\nGeneral options:\n --directory       Specify the path to the directory containing the subdirectories or subfiles. This flag must be used in conjunction with the preceding parent directory path.\n --help       Open the reference table for basic command syntax and general flags.\n --version       Display version number."));
        } else if (strcmp(argv[1], "--version") == 0) {
            std::endl(std::operator<<(std::cout, "0.2.151"));
        }
        else {
            std::endl(std::operator<<(std::cout, "sanires-> No input! Type '--help' to open the lookup table!"));
        }
    } else if (argc == 3) {
        if (strcmp(argv[1], "--directory") == 0) {
            std::string dir_string((const char*)argv[2]);
            std::filesystem::path dir_path(dir_string);
            cr7spd::patch_file(&dir_path, &arrNameDollar);
            cr7spd::scanFileContent(&dir_path, &arrNameDollar);
        }
        else {
            std::endl(std::operator<<(std::cout, "sanires-> Invalid option flag! Type '--help' to open the lookup table!"));
        }
        //...
    }
    else {
        std::endl(std::operator<<(std::cout, "sanires-> Too many arguments. A maximum of 3 arguments is allowed: the executable file path, optional flags, and the specified parent directory path! Type '--help' to open the lookup table!"));
    }
    return 0;
}
