/*
 * **************************************************-
 * Ingrid Server OpenSearch
 * ==================================================
 * Copyright (C) 2014 - 2020 wemove digital solutions GmbH
 * ==================================================
 * Licensed under the EUPL, Version 1.1 or – as soon they will be
 * approved by the European Commission - subsequent versions of the
 * EUPL (the "Licence");
 * 
 * You may not use this work except in compliance with the Licence.
 * You may obtain a copy of the Licence at:
 * 
 * http://ec.europa.eu/idabc/eupl5
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the Licence is distributed on an "AS IS" basis,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the Licence for the specific language governing permissions and
 * limitations under the Licence.
 * **************************************************#
 */
package de.ingrid.iplug.dsc.util;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;

import de.ingrid.utils.dsc.Column;
import de.ingrid.utils.dsc.Record;
import de.ingrid.iplug.dsc.schema.RecordReader;
import de.ingrid.iplug.dsc.schema.Table;
import de.ingrid.utils.dsc.UniqueObject;

/**
 * Just an util to process common ui related operations
 * 
 * @author fh
 * 
 */
public class UiUtil {

	public static String[] tableSplit(String tableCol) {
		if (tableCol == null) {
			return new String[2];
		}
		int indexOfSplitter = tableCol.indexOf("##@@##");
		String tableName = tableCol.substring(0, indexOfSplitter);
		String colName = tableCol.substring(indexOfSplitter + 6);
		return new String[] { tableName, colName };
	}

	/**
	 * @param tables
	 * @param tableName
	 * @return a table object matching the name
	 */
	public static Table getTableByName(Table[] tables, String tableName) {
		for (int i = 0; i < tables.length; i++) {
			Table table = tables[i];
			if (table.getTableName().equals(tableName)) {
				return table;
			}
		}
		return null;
	}

	/**
	 * @param serializable
	 * @return a deep cloned object includiding complete stack
	 * @throws Exception
	 */
	public static Serializable deepClone(Serializable serializable)
			throws Exception {
		ByteArrayOutputStream arrayOutputStream = new ByteArrayOutputStream();
		new ObjectOutputStream(arrayOutputStream).writeObject(serializable);
		ByteArrayInputStream bais = new ByteArrayInputStream(arrayOutputStream
				.toByteArray());
		return (Serializable) new ObjectInputStream(bais).readObject();
	}

	/**
	 * @param columns
	 * @param columnToString
	 *            the full column name as tableName DOT columnName e.g.
	 *            table.column
	 * @return the column instance or null
	 */
	public static Column getColumnByName(Column[] columns, String columnToString) {
		for (int i = 0; i < columns.length; i++) {
			Column column = columns[i];
			if (column.toString().equals(columnToString)) {
				return column;
			}
		}
		return null;

	}

	/**
	 * @param objects
	 * @param id
	 * @return the object that matches the id or null
	 */
	public static UniqueObject getUniqueObjectById(UniqueObject[] objects,
			int id) {

		for (int i = 0; i < objects.length; i++) {
			UniqueObject object = objects[i];
			if (object.getId() == id) {
				return object;
			}
		}
		return null;
	}

	/**
	 * @param tables
	 * @param columnId
	 * @return a column that match the id or null
	 */
	public static Column getColumnFromTables(Table[] tables, int columnId) {
		if (tables != null) {
			for (int i = 0; i < tables.length; i++) {
				Table table = tables[i];
				Column[] columns = table.getColumns();
				for (int j = 0; j < columns.length; j++) {
					Column column = columns[j];
					if (column.getId() == columnId) {
						return column;
					}
				}
			}
		}
		return null;
	}

	/**
	 * @param tables
	 * @param columnId
	 * @return a table contains a column matching the key or null
	 */
	public static Table getTableContainsColumn(Table[] tables, int columnId) {
		for (int i = 0; i < tables.length; i++) {
			Table table = tables[i];
			Column[] columns = table.getColumns();
			for (int j = 0; j < columns.length; j++) {
				Column column = columns[j];
				if (column.getId() == columnId) {
					return table;
				}
			}
		}
		return null;

	}
	
	
	public static String renderTable (RecordReader reader)throws Exception{
		int count = 0;
		StringBuffer buffer = new StringBuffer();
		Record record;
		while((record = reader.nextRecord())!=null){ 
			if(count++>9){
				break;
			}
			if(count==1){
				renderHeader(record, buffer);
			}		
			renderRow(record, buffer);
		} 
		return	buffer.toString();
	}

	public static void renderHeader(Record record, StringBuffer buffer){
		buffer.append("<tr>");	
		int num = record.numberOfColumns();	
			for(int i=0; i < num; i++){
				Column colum = record.getColumn(i);
				if(colum.toIndex()){
					buffer.append("<td style=\"background-color:#959595;color:#FFFFFF;font-weight:bold\">");
					buffer.append(colum.getTargetName());
					buffer.append("</td>");	
				}
			}
			Record[] subRecords  = record.getSubRecords();
			if (subRecords!=null && subRecords.length != 0) {
				buffer.append("<td style=\"background-color:#959595;color:#FFFFFF;font-weight:bold\">Subrecords (1:n)</td>");
			}
			buffer.append("</tr>");	
	}

	public static void renderRow(Record record, StringBuffer buffer) {
		int num = record.numberOfColumns();	
		buffer.append("<tr>");	
		// columns
		for(int i=0; i < num; i++){		
			Column colum = record.getColumn(i);
			if(colum.toIndex()){
				String value = record.getValueAsString(colum);
				if (value.length() > 100) {
					value = value.substring(0,100)+" ...";
				}		
				buffer.append("<td bgcolor=\"#FFFFFF\">" +java.net.URLEncoder.encode(value) +"&nbsp;</td>");
			}		
		}
		//	sub records
		Record[] subRecords  = record.getSubRecords();
		if(subRecords!=null && subRecords.length != 0){		
			buffer.append("<td bgcolor=\"#FFFFFF\">");
			buffer.append("<table bgcolor=\"#F4F4F4\" cellpadding=\"2\" cellspacing=\"2\" style=\"border:1px solid #959595\"");
			for(int j =0; j < subRecords.length; j++){			
				Record oneRecord = subRecords[j];
				if(j==0){
					renderHeader(oneRecord, buffer);
				}
				renderRow(oneRecord, buffer);			
			}
			buffer.append("</table>");				
			buffer.append("&nbsp;</td>");		
		}	
		buffer.append("</tr>");
	}
	

}
