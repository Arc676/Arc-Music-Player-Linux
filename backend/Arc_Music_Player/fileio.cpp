#include "fileio.h"

FileIO::FileIO(QObject *parent) : QObject(parent){}
FileIO::~FileIO() {}

void FileIO::writeToFile(const QString &filename, const QString &text){
    QFile file(filename);
    if (file.open(QFile::WriteOnly | QFile::Truncate)) {
        QTextStream stream(&file);
        stream << text << endl;
        file.close();
    }
}

QString FileIO::readFromFile(const QString &filename){
    QFile file(filename);
    if (file.open(QFile::ReadOnly)) {
        QTextStream content(&file);
        QString text = content.readAll();
        file.close();
        return text;
    }
    return "";
}
