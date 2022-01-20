#ifndef XMLREADER_H
#define XMLREADER_H
#include <QtXml>
#include <QFile>
#include "applicationsmodel.h"


class XmlReader :public QObject
{
    Q_OBJECT
public:
    XmlReader(QString filePath, ApplicationsModel &model);
    XmlReader();
    Q_INVOKABLE void xmlWriter();
    Q_INVOKABLE void addItemtoList(QString idApp,QString title,QString url,QString iconPath);
private:
    QDomDocument m_xmlDoc; //The QDomDocument class represents an XML document.
    QList<ApplicationItem> m_item;
    bool ReadXmlFile(QString filePath);
    void PaserXml(ApplicationsModel &model);


};

#endif // XMLREADER_H
