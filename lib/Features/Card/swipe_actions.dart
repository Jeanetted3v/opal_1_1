// Function to record the swipe action
void recordSwipeAction(int cardIndex, String direction) {
  // Add your logic here to record the swipe
  // For example, logging it or updating a database
  print('Card at index $cardIndex was swiped $direction');
}

void recordLeftSwipe(int index) {
  // Implement your logic for recording a left swipe
  print('Record Card at index $index was swiped left');
}

void recordRightSwipe(int index) {
  // Implement your logic for recording a right swipe
  print('Record Card at index $index was swiped right');
}

void recordUnSwipe(int index) {
  // Implement your logic for recording an unswipe
  // This could involve updating a state, logging the action, or sending data to a server
  print('An unswipe action was performed.');
  print('Record Card at index $index was swiped right');

  // Add any additional logic specific to an unswipe action
  // For example, updating a counter, modifying application state, etc.
}

void _onEnd() {
  print('end reached!');
}