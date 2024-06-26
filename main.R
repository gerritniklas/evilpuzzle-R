evilPuzzel <- function(word = 'mein', nrow = 10, ncol = 10, includeWord = TRUE){
  letters <- strsplit(word, split = "")[[1]]
  wordLength <- length(letters)
  
  if (length(unique(letters)) < 3) {
    stop("Word must contain at least 3 unique characters!")
  }
  
  if(wordLength > nrow || wordLength > ncol){
    stop("Word does not fit in matrix!")
  }
  
  matx <- matrix(sample(letters, size = nrow * ncol, replace = TRUE), 
                 nrow=nrow, 
                 ncol=ncol)
  
  wordCount <- 0
  wordFound <- TRUE
  
  while (wordFound) {
    wordFound <- FALSE
      
    for(i in 1:nrow){
      for(j in 1:ncol){
        endIndexCol <- (j-1 + wordLength)
        endIndexRow <- (i-1 + wordLength)
        
        # Check columns
        if(endIndexCol <= ncol){
          segment <- matx[i, j:endIndexCol]
          if (identical(segment, letters) || identical(rev(segment), letters)) {
            matx[i, j:endIndexCol] <- sample(letters, wordLength, replace = TRUE)
            wordFound <- TRUE
            wordCount <- wordCount + 1
          }
        }
        
        # Check rows
        if(endIndexRow <= nrow){
          segment <- matx[i:endIndexRow, j]
          if (identical(segment, letters) || identical(rev(segment), letters)) {
            matx[i:endIndexRow, j] <- sample(letters, wordLength, replace = TRUE)
            wordFound <- TRUE
            wordCount <- wordCount + 1
          }
        }
        
        # Check diagonals from top left to bottom right
        if(endIndexRow <= nrow && endIndexCol <= ncol){
          segment <- diag(matx[i:endIndexRow, j:endIndexCol])
          if (identical(segment, letters) || identical(rev(segment), letters)) {
            diag(matx[i:endIndexRow, j:endIndexCol]) <- sample(letters, wordLength, replace = TRUE)
            wordFound <- TRUE
            wordCount <- wordCount + 1
          }
        }

        # Check diagonals from top right to bottom left
        if (endIndexRow <= nrow && j >= wordLength){
          segment <- diag(matx[i:endIndexRow, j:(j+1 - wordLength)])
          if (identical(segment, letters) || identical(rev(segment), letters)) {
            diag(matx[i:endIndexRow, j:(j+1 - wordLength)]) <- sample(letters, wordLength, replace = TRUE)
            wordFound <- TRUE
            wordCount <- wordCount + 1
          }
        }
        
      }
    }
    
  }
  
  if (includeWord) {
    direction <- sample(1:4, 1) 
    if (direction == 1) {
      # Horizontal
      row <- sample(1:nrow, 1)
      col <- sample(1:(ncol - wordLength + 1), 1)
      matx[row, col:(col + wordLength - 1)] <- letters
    } else if (direction == 2) {
      # Vertical
      row <- sample(1:(nrow - wordLength + 1), 1)
      col <- sample(1:ncol, 1)
      matx[row:(row + wordLength - 1), col] <- letters
    } else if (direction == 3) {
      # Diagonal TL-BR
      row <- sample(1:(nrow - wordLength + 1), 1)
      col <- sample(1:(ncol - wordLength + 1), 1)
      for (k in 0:(wordLength - 1)) {
        matx[row + k, col + k] <- letters[k + 1]
      }
    } else if (direction == 4) {
      # Diagonal TR-BL
      row <- sample(1:(nrow - wordLength + 1), 1)
      col <- sample(wordLength:ncol, 1)
      for (k in 0:(wordLength - 1)) {
        matx[row + k, col - k] <- letters[k + 1]
      }
    }
    print(paste("Zeile:", row, "Spalte:", col))
  }
  
  print(paste("Wörter ersetzt:", wordCount))
  return(matx)
}

evilPuzzel('dog', 15, 10)