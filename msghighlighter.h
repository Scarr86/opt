#ifndef MSGHIGHLIGHTER_H
#define MSGHIGHLIGHTER_H


#include <QSyntaxHighlighter>
#include <QRegularExpressionMatchIterator>

class MsgHighlighter: public QSyntaxHighlighter {
    Q_OBJECT

public:
    explicit MsgHighlighter(QTextDocument *parent = 0);

protected:
    void highlightBlock(const QString &text) Q_DECL_OVERRIDE;
};

#endif // MSGHIGHLIGHTER_H
