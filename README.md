An expandable navigation bar with custom segmented control.

## Description
An expandable search bar with custom segmented controls. 

We created a custom navigation bar with search field and segmented controls embedded in it.

The navigation bar gets stretched if the user scrolls up the content, or if the user clicks inside the search field. 
If the search field is closed, or the user scrolls down the content significantly the navigation bar expands.
In expanded state, you can see title, search field and segmented controls, but in stretched navigation bar state
the title isn't visible.


To make the navigation bar appear consistent, I used a custom **ScrollTargetBehavior** to either allow the navigation bar
stay in expanded state or transition to stretched state, and vice versa.


I used matched geometry effect and snappy animation for custom segmented controls, and a custom transition to display the 
closed search button.

## Next steps
The code works, but there are still a few rough edges that I want to work on next. Here they are:
- [x] Modify the code and make it more readable.
- [ ] Make a component out of the code to make it reusable.

## Usage
To be provided later. After the component is made reusable, I will provide the instructions here.

Soon to be updated!

## Screenshots
<img src="/Screenshots/App.gif" alt="App testing gif">
