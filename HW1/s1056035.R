# Name : Rosdyana Kusuma
# Student ID : s1056035
# mail : me@rosdyanakusuma.com , rosdyana.kusuma@gmail.com
# site : rosdyanakusuma.com

# read input data.
dataInput = read.csv("input.csv", header=F , sep=",")

# set lenght of input data.
lengthV1 = length(unique(dataInput$V1)) 
lengthV2 = length(unique(dataInput$V2))

# create a matrix from input data.
x = rep(c(0), times=lengthV1*lengthV1)
dim(x)=c(lengthV1,lengthV1)
#colnames(x) = c(unique(dataInput$V1))

# create confusion matrix.
for (j in 1:lengthV1) { 
  for (k in 1:lengthV2) {
    x[j,k] = length(which(dataInput$V2 == k & dataInput$V1 == j)) 
  } 
}

# check the matrix result
x

appliedCol = NULL
maxVal = max(x)
minVal = min(x)

# re-position the highest value in column based on their row position.
for(a in maxVal:minVal)
{
  # check value is exist or not
  if( a %in% x){
    # get current position
    CurPos = which(x[,] == a, arr.ind=T)  
    
    # extract the postion
    RowPos = CurPos[1]
    ColPos = CurPos[2]
    
    if(any(appliedCol==ColPos) ){
      print("column fixed") 
    } else {
      if(is.null(appliedCol) || !(RowPos %in% appliedCol) ){
        print("moved to new column")
        x[ , c(ColPos,RowPos)] <- x[ , c(RowPos,ColPos)]
        appliedCol = append(appliedCol,RowPos)    
      } else {
        print("column already assigned")
      }
    }
    print(x)   
  }
}

# check the matrix result
x
# write into output.csv
write.table(x, file="output.csv",col.names=F,row.names=F,sep = ",") 

