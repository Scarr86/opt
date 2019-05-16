#include "msghighlighter.h"
#include <QtDebug>

MsgHighlighter::MsgHighlighter(QTextDocument *parent): QSyntaxHighlighter (parent) {

}

void MsgHighlighter::highlightBlock(const QString &text) {
    QTextCharFormat msgFormat;
    qDebug() << "Вызван хайлайтер";
    msgFormat.setForeground(Qt::green);

    QRegularExpression expression(">>");
    QRegularExpressionMatchIterator i = expression.globalMatch(text);
    while(i.hasNext()) {
        QRegularExpressionMatch match = i.next();
        setFormat(match.capturedStart(), match.capturedLength(), msgFormat);
    }
}
