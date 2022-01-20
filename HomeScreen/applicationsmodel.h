#ifndef APPLICATIONSMODEL_H
#define APPLICATIONSMODEL_H
#include <QAbstractListModel>
#include <QDebug>

class ApplicationItem {
public:
    ApplicationItem(QString idApp,QString title, QString url, QString iconPath);

    QString idApp() const;

    QString title() const;

    QString url() const;

    QString iconPath() const;


private:
    QString m_idapp;
    QString m_title;
    QString m_url;
    QString m_iconPath;
};

class ApplicationsModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum Roles {
        TitleRole = Qt::UserRole + 1,
        UrlRole,
        IconPathRole,
        IdAppRole
    };
    explicit ApplicationsModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    void addApplication(ApplicationItem &item);

protected:
    QHash<int, QByteArray> roleNames() const override;

private:
    QList<ApplicationItem> m_data;
};

#endif // APPLICATIONSMODEL_H
