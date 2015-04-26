/*
 * This file is part of kdictionary_qml.

 * kdictionary_qml is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * kdictionary_qml is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.

 * You should have received a copy of the GNU Lesser General Public License
 * along with kdictionary_qml.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.4
import QtQuick.XmlListModel 2.0

Item {
    property string resultText
    property alias progress: youdaoModel.progress
    
    XmlListModel {
        id: youdaoModel
        query: '/youdao-fanyi'
        
        XmlRole { name: 'errcode'; query: 'errorCode/string()' }
        XmlRole { name: 'translation'; query: 'translation/string()' }//YOUDAO Translation
        XmlRole { name: 'phonetic'; query: 'basic/phonetic/string()' }//YOUDAO Basic Dictionary
        XmlRole { name: 'explains'; query: 'basic/explains/string()' }
        XmlRole { name: 'webkey' ; query: 'web/explain[1]/key/string()' }//YOUDAO Web Dictionary
        XmlRole { name: 'web'; query: 'web/explain[1]/value/string()' }
        XmlRole { name: 'webkey2' ; query: 'web/explain[2]/key/string()' }
        XmlRole { name: 'web2'; query: 'web/explain[2]/value/string()' }
        XmlRole { name: 'webkey3' ; query: 'web/explain[3]/key/string()' }
        XmlRole { name: 'web3'; query: 'web/explain[3]/value/string()' }
        
        onCountChanged: parse()
        onSourceChanged: reload()
    }
    
    function query(words) {
        youdaoModel.source = 'http://fanyi.youdao.com/openapi.do?keyfrom=KDictionary&key=813148993&type=data&doctype=xml&version=1.1&q=' + words
    }
    
    function parse() {
        if (youdaoModel.get(0).errcode !== '0') {
            switch (youdaoModel.get(0).errcode) {
                case '20':
                    resultText = qsTr('The input text is too long.')
                    break
                case '30':
                    resultText = qsTr('Cannot translate it correctly.')
                    break
                case '40':
                    resultText = qsTr('Unsupported language.')
                    break
                case '50':
                    resultText = qsTr('Invalid key.')
                    break
                default:
                    resultText = qsTr('Unknown error.')
            }
        } else {
            resultText = ''
            if (youdaoModel.get(0).phonetic !== '')
                resultText += '<b>' + qsTr('Phonetic:') + '</b> <i>/'
                            + youdaoModel.get(0).phonetic + '/</i><br /><br />'
            if (youdaoModel.get(0).explains !== '')
                resultText += '<b>' + qsTr('Definitions:') + '</b><br />'
                            + youdaoModel.get(0).explains + '<br /><br />'
            if (youdaoModel.get(0).translation !== '')
                resultText += '<b>' + qsTr('Translation:') + '</b><br />'
                            + youdaoModel.get(0).translation + '<br /><br />'
            if (youdaoModel.get(0).webkey !== '')
                resultText += '<b>' + qsTr('Web Definitions:') + '</b><br />'
                            + youdaoModel.get(0).webkey + qsTr(': ')
                            + youdaoModel.get(0).web
                            + '<br />' + youdaoModel.get(0).webkey2 + qsTr(': ')
                            + youdaoModel.get(0).web2
                            + '<br />' + youdaoModel.get(0).webkey3 + qsTr(': ')
                            + youdaoModel.get(0).web3
        }
    }
}
