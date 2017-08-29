#ifndef FILEIO_H
#define FILEIO_H

#include <QObject>
#include <QFile>
#include <QTextStream>

class FileIO : public QObject{
    Q_OBJECT

public:
    explicit FileIO(QObject *parent = 0);
    ~FileIO();

public slots:
    Q_INVOKABLE void writeToFile(const QString &filename, const QString &text);
    Q_INVOKABLE QString readFromFile(const QString &filename);

};

#endif // FILEIO_H
