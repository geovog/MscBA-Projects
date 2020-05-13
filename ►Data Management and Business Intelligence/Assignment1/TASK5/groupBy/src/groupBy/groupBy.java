package groupBy;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.DriverManager;
import java.sql.Statement;
import java.text.DecimalFormat;

public class groupBy {
	
	private static final String url = "jdbc:mysql://localhost:3306/crc?autoReconnect=true&useSSL=false";
	private static final String user = "root";
	private static final String password = "6978147098";
	private static Double[] monthAmounts = new Double[12];
	private static DecimalFormat df = new DecimalFormat("0.00"); 
	
	public static void main(String args[]) 
    {
		aggregateData();
    }
	
	private static void aggregateData()

    {	
	 		for(int i=0; i<12; i++)
    		{
	 			monthAmounts[i]= 0.0;
    	  	}
    
       
	 try (Connection connection = DriverManager.getConnection(url, user, password))
        {
            String query = "select amount, month(since) as month from crc.lease where year(since)=2015";
            Statement stmt = connection.createStatement();
            ResultSet rs = null;
            rs = stmt.executeQuery(query);
           
            while(rs.next())
            {
            	int month = rs.getInt("month");
            	double amount = rs.getDouble("amount");
            	
            	if(month==1)
            		monthAmounts[month-1]+=amount;
            	else if(month==2)
            		monthAmounts[month-1]+=amount;
            	else if(month==3)
            		monthAmounts[month-1]+=amount;
            	else if(month==4)
            		monthAmounts[month-1]+=amount;
            	else if(month==5)
            		monthAmounts[month-1]+=amount;
            	else if(month==6)
            		monthAmounts[month-1]+=amount;
            	else if(month==7)
            		monthAmounts[month-1]+=amount;
            	else if(month==8)
            		monthAmounts[month-1]+=amount;
            	else if(month==9)
            		monthAmounts[month-1]+=amount;
            	else if(month==10)
            		monthAmounts[month-1]+=amount;
            	else if(month==11)
            		monthAmounts[month-1]+=amount;
            	else if(month==12)
            		monthAmounts[month-1]+=amount;
            }
            rs.close();
            stmt.close();
            connection.close();
           
            System.out.println("Month\tPrevious months\tCurrent month\tFollowing months");
            for (int month = 0; month < 12; month++) 
            {
            	System.out.print(month+1+"\t");
            	double previousMonthsAmount = 0;
            	for (int p = 0; p < month; p++)
            	{
            		previousMonthsAmount += monthAmounts[p];
            	}
            	System.out.printf("%10s",df.format(previousMonthsAmount));
            	System.out.print("\t");
            	System.out.printf("%10s",df.format(monthAmounts[month]));
            	System.out.print("\t");
            	double nextMonthsAmount = 0;
            	for (int n = month + 1; n < 12; n++) 
            	{
            		nextMonthsAmount+= monthAmounts[n];
            	}
            	System.out.println("\t"+df.format(nextMonthsAmount));
            }
        }
        catch (Exception e)
        {
                e.printStackTrace();
        }
    }

}
