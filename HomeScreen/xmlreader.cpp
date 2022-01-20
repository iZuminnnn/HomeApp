#include "xmlreader.h"

XmlReader::XmlReader(QString filePath, ApplicationsModel &model)
{
    ReadXmlFile(PROJECT_PATH + filePath);
    PaserXml(model);
}

XmlReader::XmlReader()
{
    qDebug()<<"Hello";

}

void XmlReader::xmlWriter()
{

    QDomDocument m_xmlWrite;
    QDomElement root = m_xmlWrite.createElement("APPLICATION");
    m_xmlWrite.appendChild(root);
    for(int i = 0; i < m_item.count(); i++){

    QDomElement node = m_xmlWrite.createElement("APP");
    node.setAttribute("ID",m_item.at(i).idApp());
    root.appendChild(node);

    QDomElement xtitle = m_xmlWrite.createElement("TITLE");
    node.appendChild(xtitle);
    QDomText contentTitle = m_xmlWrite.createTextNode(m_item.at(i).title());
    xtitle.appendChild(contentTitle);


    QDomElement xurl = m_xmlWrite.createElement("URL");
    node.appendChild(xurl);
    QDomText contentUrl = m_xmlWrite.createTextNode(m_item.at(i).url());
    xurl.appendChild(contentUrl);

    QDomElement icon_path = m_xmlWrite.createElement("ICON_PATH");
    node.appendChild(icon_path);
    QDomText contentPath = m_xmlWrite.createTextNode(m_item.at(i).iconPath());
    icon_path.appendChild(contentPath);
}

    QString path = PROJECT_PATH;
    QFile file (path + "applications.xml");

    if(!file.open(QIODevice::WriteOnly))
    {
        qDebug()<<"Failed to Open file";
    }else{
        QTextStream stream(&file);
        stream << m_xmlWrite.toString();
        file.close();

    }
    m_item.clear();

}

void XmlReader::addItemtoList(QString idApp, QString title, QString url, QString iconPath)
{
    ApplicationItem item(idApp,title,url,iconPath);
   // qDebug()<< item.idApp() << "\n" << item.url()<<"\n" << item.iconPath() <<"\n" ;
    m_item.append(item);
}



bool XmlReader::ReadXmlFile(QString filePath)
{
    // Load xml file as raw data
    QFile f(filePath);
    qDebug() << "file Path: " << filePath;
    if (!f.open(QIODevice::ReadOnly ))
    {
        // Error while loading file
        return false;
    }
    // Set data into the QDomDocument before processing
    m_xmlDoc.setContent(&f);
    f.close();
    return true;
}

void XmlReader::PaserXml(ApplicationsModel &model)
{
    // Extract the root markup
    QDomElement root=m_xmlDoc.documentElement();

    // Get the first child of the root (Markup COMPONENT is expected)
    QDomElement Component=root.firstChild().toElement();

    // Loop while there is a child
    while(!Component.isNull())
    {
        // Check if the child tag name is COMPONENT
        if (Component.tagName()=="APP")
        {

            // Read and display the component ID
            QString ID=Component.attribute("ID","No ID");


            // Get the first child of the component
            QDomElement Child=Component.firstChild().toElement();

            QString title;
            QString url;
            QString iconPath;

            // Read each child of the component node
            while (!Child.isNull())
            {
                // Read Name and value

                if (Child.tagName()=="TITLE") title = Child.firstChild().toText().data();
                if (Child.tagName()=="URL") url = Child.firstChild().toText().data();
                if (Child.tagName()=="ICON_PATH") iconPath = Child.firstChild().toText().data();

                // Next child
                Child = Child.nextSibling().toElement();
            }
            ApplicationItem item(ID,title,url,iconPath);
            model.addApplication(item);
        }

        // Next component
        Component = Component.nextSibling().toElement();
    }
}



