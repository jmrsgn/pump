class AppStrings {
  AppStrings._();

  // Common Strings
  static const email = "Email";
  static const password = 'Password';
  static const allYouNeedInOneApp = "All you need, in one app";
  static const routeNotFound = "Route not found";
  static const signOut = "Sign out";
  static const goBack = "Go back";
  static const name = "Name";
  static const message = "Message";
  static const submit = "Submit";
  static const unknownError = "Unknown error";
  static const routeError = "Route error";
  static const likes = "likes";
  static const liked = "Liked";
  static const comments = "comments";
  static const shares = "shares";
  static const like = "Like";
  static const reply = "Reply";
  static const typeAMessage = "Type a message";
  static const user = "User";
  static const close = "Close";
  static const compare = "Compare";
  static const somethingWentWrongPleaseTryAgain =
      "Something went wrong. Please try again.";

  // Post related
  static const editPost = "Edit post";
  static const deletePost = "Delete post";
  static const createPost = "Create post";

  // Comment related
  static const editComment = "Edit comment";
  static const deleteComment = "Delete comment";

  // Login Page
  static const login = 'Login';
  static const emailAndPasswordAreRequired = "Email and password are required";
  static const enterAValidEmail = "Enter a valid email";
  static const passwordMustBeAtLeast6Characters =
      "Password must be at least 6 characters";

  // Register Page
  static const register = 'Register';
  static const userRegistration = "User Registration";
  static const firstName = "First Name";
  static const lastName = "Last Name";
  static const phone = "Phone";
  static const role = "Role";
  static const client = "Client";
  static const iAmSigningUpAsA = "I am signing up as a";
  static const allFieldsAreRequired = "All fields are required";
  static const userRegisteredSuccessfully = "User registered successfully";
  static const phPhonePrefix = "+63";

  // Main Feed Page
  static const comment = "Comment";
  static const share = "Share";

  // About Page
  static const about = "About";
  static const aboutPage = "About page";
  static const inspiration = "Inspiration";
  static const howItWorks = "How it works";
  static const developer = "Developer";
  static const contactDetails = "Contact Details";
  static const github = "GitHub";

  // Profile Page
  static const profile = "Profile";
  static const editProfile = "Edit Profile";
  static const paymentMethod = "Payment Method";
  static const clients = "Clients";
  static const coach = "Coach";
  static const help = "Help";
  static const active = "Active";
  static const inactive = "Inactive";

  // Feedback Page
  static const feedback = "Feedback";
  static const letMeKnowWhatToImprove = "Let me know what to improve :>";

  // Liked Posts Page
  static const likedPosts = "Liked Posts";

  // Contact Page
  static const contact = "Contact";
  static const letsTalk = "Let's talk";
  static const isThereAnytingICanHelpYouWith =
      "Is there anything I can help you with?";

  // Messages Page
  static const messages = "Messages";

  static String get copyright => '© ${DateTime.now().year} All Rights Reserved';

  // Coaching Page
  static const coaching = "Coaching";

  // Clients Page
  static const enroll = "Enroll";
  static const searchClients = "Search Clients";

  // Client Info Page
  static const clientInfo = "Client Info";
  static const physicalStats = "Physical Stats";
  static const height = "Height";
  static const weight = "Weight";
  static const bodyFat = "Body Fat";
  static const muscleMass = "Muscle Mass";
  static const trainingInfo = "Training Info";
  static const lastWorkout = "Last Workout";
  static const nutritionInfo = "Nutrition Info";
  static const progressAndAnalytics = "Progress & Analytics";
  static const graphsAndProgressPhotos = "Graphs & Progress Photos";
  static const tapToViewChartsAndPhotos = "Tap to view charts and photos";
  static const tapToViewTrainingBlock = "Tap to view training block";
  static const coachingNotes = "Coaching Notes";
  static const extras = "Extras";
  static const trainingBlock = "Training Block";

  static String programTemplate(String program) => "Program: $program";

  static String startDateTemplate(String startDate) => "Start Date: $startDate";

  static String frequencyTemplate(String frequency) => "Frequency: $frequency";

  static String dailyCaloriesTemplate(String dailyCalories) =>
      "Daily Calories: $dailyCalories";

  static String macrosTemplate(String protein, String carbs, String fat) =>
      "Macros: P:$protein | C:$carbs | F:$fat";

  static String mealPlanTemplate(String mealPlan) => "Meal Plan: $mealPlan";

  static String nextCheckInTemplate(String nextCheckIn) =>
      "Next Check-in: $nextCheckIn";

  static String lastNoteTemplate(String lastNote) => "Last Note: $lastNote";

  static String remindersTemplate(String reminders) => "Reminders: $reminders";

  static String supplementsTemplate(String supplements) =>
      "Supplements: $supplements";

  static String injuriesTemplate(String injuries) => "Injuries: $injuries";

  // Progress and Analytics Page
  static const week = "Week";
  static const date = "Date";
  static const weightInLbs = "Weight (lbs)";
  static const weeklyAvg = "Weekly Avg";
  static const weeklyRate = "Weekly Rate";
  static const noteOrAdjustment = "Note / Adjustment";
  static const kgOrLbs = "kg / lbs";
  static const noNumberInputTemplate = "###";
  static const tapToViewCheckins = "Tap to view checkins";

  // Training Block Page
  static const pull = "Pull";
  static const legs = "Legs";
  static const push = "Push";
  static const rest = "Rest";
  static const fullBody = "Full Body";
  static const upperBody = "Upper Body";
  static const lowerBody = "Lower Body";
  static const cardio = "Cardio";

  static String weekNoTemplate(int weekNo) => "Week $weekNo";

  static String dayNoSplitTemplate(int dayNo, String split) =>
      "Day $dayNo $split";

  // --------------------------

  // Dev Info
  static const devEmail = "marasiganjohnmartin@gmail.com";
  static const devMobileNo = "+639 56 172 3007";
  static const devGithubUsername = "jmrsgn";

  // Placeholder
  static const placeholder = "Placeholder";
  static const placeholderParagraph =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer aliquam purus urna, in fringilla massa dictum lacinia. Fusce vel felis et nunc rutrum sagittis. Etiam ac volutpat sapien.";
  static const placeholderParagraph2 =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean ac tempus felis. Nam sollicitudin ex et risus feugiat luctus a et dui.";
}
