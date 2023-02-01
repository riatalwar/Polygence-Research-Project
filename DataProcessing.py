import csv

file = open('Polygence-Data\OxygenPhosphateSilicateNitrate.csv')
data = []
# read in data
for row in file.readlines():
    elements = row.strip().split(',')[:-1]
    for i in range(len(elements)):
        elements[i] = elements[i].strip()
    data.append(elements)
file.close()

newCSV = open('Polygence-Data\\filtered.csv', 'w', newline='')
csvWriter = csv.writer(newCSV, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
csvWriter.writerow(['Latitude', 'Longitude', 'Year', 'Month', 'Day', 'Time', 'Oxygen', 'Phosphate', 'Silicate', 'Nitrate'])

# gather desired data
rowNum = 0
LOC_TIME_VAR = ['Latitude', 'Longitude', 'Year', 'Month', 'Day', 'Time']
ENV_VAR = ['Oxygen', 'Phosphate', 'Silicate', 'Nitrate']

while rowNum < len(data):
    # reset various tracker variables
    row = data[rowNum]
    outData = {}
    newgroup = False

    while not newgroup:
        rowNum += 1
        row = data[rowNum]

        # check if one of desired variables exists in row
        for var in LOC_TIME_VAR:
            if var in row:
                outData[var] = row[2]
                break
        
        if row[0] == 'VARIABLES':
            # get indexes for each environmental variable
            envVarIndex = []
            for var in ENV_VAR:
                if var in row:
                    envVarIndex.append(row.index(var))
                else:
                    envVarIndex.append(-1)
            
            # determine if there is actually data to be collected
            isData = False
            for i in envVarIndex:
                if i != -1:
                    isData = True
                    break

            rowNum += 1
            row = data[rowNum]
            while not newgroup and isData:
                # add predetermined vars to row
                newRow = [outData[var] for var in LOC_TIME_VAR]
                # add new env vars
                envVars = []
                for i in envVarIndex:
                    if row[i] != '---*---' and row[i] != 'umol/kg':
                        envVars.append(row[i])
                    else:
                        envVars.append('')
                
                for var in envVars:
                    # write row to file if data exists
                    if var != '':
                        newRow.extend(envVars)
                        csvWriter.writerow(newRow)
                        break
                
                # move on and check if group is over
                rowNum += 1
                row = data[rowNum]
                newgroup = row[0].startswith('END OF VARIABLES SECTION')

    rowNum += 1




