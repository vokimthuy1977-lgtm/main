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
			std::cout << _element.operator*().path().string() << " [DIRECTORY]" << std::endl;
			patch_file(&(_element.operator*().path()), pArrayNameDollar);
		}
		else if (_element.operator*().is_regular_file() == true)
		{
			std::cout << _element.operator*().path().string() << " [FILE]" << std::endl;
			std::string nameFile = _element.operator*().path().filename().string();
			if (nameFile[0] == '$')
			{
				(*pArrayNameDollar).push_back(nameFile);
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
	unsigned long posFind = 0;
	unsigned long indexC;
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
		posFind = indexC + _stringFind.length();
	}
}
void scanFileContent(const std::filesystem::path* _dir_path, std::vector<std::string>* pArrayNameDollar) {
	std::filesystem::directory_iterator _element(*_dir_path);
	std::filesystem::directory_iterator _end;
	while (_element != _end) {
		if (_element.operator*().is_directory() == true) {
			scanFileContent(&(_element.operator*().path()), pArrayNameDollar);
		} else if (_element.operator*().is_regular_file() == true) {
			std::filesystem::path r = _element.operator*().path();
			std::string fw = r.replace_extension("").string() + ".tmp";
			std::ofstream file_write(fw);
			std::ifstream file_read(_element.operator*().path());
			std::string line;
			while (getline(file_read, line)) {
				for (std::string nameDollar : *pArrayNameDollar) {
					std::string nameFix = nameDollar;
					nameFix[0] = '_';
					replaceString(line, nameDollar, nameFix);
				}
				file_write << line << "\n";
			}
			std::filesystem::path fileOld(fw)
			std::filesystem::remove(r);
			std::filesystem::rename(fileOld, r);
		}
		_element.operator++();
	}
}
} // namespace cr7spd
int main()
{
	std::vector<std::string> arrNameDollar;
	std::filesystem::path dir_path = ".";
	cr7spd::patch_file(&dir_path, &arrNameDollar);
	// test string
	std::string hello = "Xin chao cac ban cua toi haha!";
	cr7spd::replaceString(hello, "ban", "Lop 9G");
	std::cout << hello << std::endl;
	return 0;
}