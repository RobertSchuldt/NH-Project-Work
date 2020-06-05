# -*- coding: utf-8 -*-
"""
Created on Fri Jun  5 12:40:53 2020

@author: Robert Schuldt

Converting the PDF to tables for Dr Felix work on the NH per diem
payment rates for patients. Data sourced from Genworth national survey
on care
"""

pdf_convert17 = "C:\\Us************************* Cost of Care\\2017 Cost of Care Annualized.pdf" 
doc17 = "C:\*****************************"
pdf_convert18 = "C******************************ost of Care\\2018  Cost of Care.pdf" 
doc18 = "**********************************re\\cost_2018"
#Need to import my PDF tables API

import pdftables_api 

def pdfprog(pdf_convert , doc):
    '''This connects to the conversion API'''
    c = pdftables_api.Client('**********')
    c.csv( pdf_convert , doc)
   
    print("Generated document" + str(doc)+"from pdf")
  
          
pdfprog(pdf_convert17 , doc17 )
pdfprog(pdf_convert18 , doc18 )