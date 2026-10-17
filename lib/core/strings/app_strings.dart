/// All user-facing copy text, compliance claims, and marketing strings.
///
/// Edit this file to change wording without touching any screen code.
abstract final class AppStrings {
  AppStrings._();

  // ── Get Started ───────────────────────────────────────────────────────────
  static const appName = 'YETMpay';
  static const tagline = 'Pay with your face. Nothing else.';
  static const getStarted = 'Get Started';
  static const alreadyHaveAccount =
      'I already have a merchant account \u2022 Sign in';
  static const nbeFooter =
      'Licensed & protected by National Bank of Ethiopia (NBE) \u2022\nFayda Biometric ID';

  // ── Rail badges ───────────────────────────────────────────────────────────
  static const railTelebirr = 'Telebirr';
  static const railCBE = 'CBE';
  static const railAwash = 'Awash';
  static const railDashen = 'Dashen';
  static const railCBEBirr = 'CBE Birr';
  static const railAmole = 'Amole';

  // ── Merchant Registration ─────────────────────────────────────────────────
  static const merchantRegistration = 'Merchant Registration';
  static const merchantRegistrationSub =
      'Accept instant face and fingerprint\npayments at your shop';
  static const fieldBusinessName = 'Business / Shop Name';
  static const fieldBusinessNameHint = 'e.g. Bole Fresh Mart';
  static const fieldOwnerName = 'Owner / Manager Full Name';
  static const fieldOwnerNameHint = 'e.g. Abebe Bikila';
  static const fieldPhone = 'Phone Number';
  static const fieldPhoneHint = '91 123 4567';
  static const fieldPIN = 'Terminal Security PIN';
  static const fieldPINHint = '\u2022\u2022\u2022\u2022\u2022\u2022';
  static const settlementRails = 'Settlement rails';
  static const continueToPayoutAccount = 'Continue to Payout Account';
  static const alreadyRegistered = 'Already registered?';
  static const signIn = 'Sign in';

  // ── Link Bank ─────────────────────────────────────────────────────────────
  static const linkSettlementAccount = 'Link Settlement Account';
  static const linkSettlementSub =
      'Where your daily customer transactions get\ndeposited instantly.';
  static const stepIndicator = 'Step 2 of 2';
  static const tabBankAccount = 'Bank Account';
  static const tabTelebirrSuperApp = 'Telebirr SuperApp';
  static const selectRailBank = 'SELECT RAIL / BANK';
  static const instantSettled = 'Instant Settled';
  static const fieldAccountNumber = 'Account Number';
  static const fieldAccountNumberHint = '13 digits';
  static const fieldLinkedMobile = 'Linked Mobile Number';
  static const faydaMatch =
      'Must match your national Fayda ID registration';
  static const accountHolderVerified = 'ACCOUNT HOLDER VERIFIED';
  static const verifiedWithCBE =
      'Verified with CBE Core \u2022 T+0 Immediate Settlement';
  static const nbeCompliance =
      'Protected under National Bank of Ethiopia clearing\nstandards.';
  static const completeActivateTerminal = 'Complete & Activate Terminal';
  static const changeSettlementRail = 'Change settlement branch or rail';
  static const matchLabel = 'Match';

  // ── Terminal ──────────────────────────────────────────────────────────────
  static const terminalReady = 'Your Terminal is Ready';
  static const terminalReadySub =
      'Bole Fresh Mart is now verified to accept\nbiometric and QR payments.';
  static const merchantProfile = 'MERCHANT PROFILE';
  static const merchantName = 'Bole Fresh Mart';
  static const merchantLocation = 'Addis Ababa, Bole Sub-City';
  static const terminalId = 'Terminal ID';
  static const terminalIdValue = 'YM-004821';
  static const payoutRail = 'Telebirr Instant';
  static const payoutConnected = 'CONNECTED';
  static const counterStandeeQR = 'COUNTER STANDEE QR';
  static const readyToScan = 'Ready to Scan';
  static const qrSupports =
      'Counter Standee QR \u2022 Supports Telebirr, CBE Birr\n& Awash';
  static const instructionText =
      'Display at checkout counter or switch to\nTerminal mode for direct face scanning.';
  static const openPaymentTerminal = 'Open Payment Terminal';
  static const downloadStandeePDF = 'Download Counter Standee PDF';
  static const tabTerminal = 'Terminal';
  static const tabTransactions = 'Transactions';
  static const tabSettings = 'Settings';
  static const merchantTerminalNum = 'Merchant Terminal #04';
  static const online = 'Online';

  // ── Charging ──────────────────────────────────────────────────────────────
  static const enterAmount = 'ENTER AMOUNT';
  static const paymentRail = 'PAYMENT RAIL';
  static const directPush = 'Direct Push';
  static const autoPayoutNote = 'Auto-payout scheduled at 23:59';
  static const settledToday = 'settled sales\ntoday';

  // ── Face Scan ─────────────────────────────────────────────────────────────
  static const charging = 'Charging';
  static const positionFace = "Position customer's face in the circle";
  static const autoVerifying = 'Auto-verifying';
  static const liveLabel = 'LIVE';
  static const switchToFingerprint = 'Switch to fingerprint scan';
  static const biometricPrivacy =
      'Biometric data is processed locally and never stored';
  static const cancelSale = 'Cancel sale';
  static const noFaceRecognized = 'No Face Recognized';
  static const noFaceSub =
      'Face not detected in frame. Switching to fingerprint biometric scanner.';
  static const continueWithFingerprint = 'Continue with Fingerprint';
  static const retryScan = 'Retry Face Scan';

  // ── Login ─────────────────────────────────────────────────────────────────
  static const loginTitle = 'Merchant Login';
  static const loginSub = 'Sign in to your merchant account';
  static const fieldEmail = 'Phone / Email';
  static const fieldPassword = 'Password';
  static const loginButton = 'Sign In';
  static const forgotPassword = 'Forgot password?';
  static const demoNote = 'Demo: use any credentials in debug mode';
  static const lockedOut = 'Too many attempts. Try again in';
  static const seconds = 'seconds';

  // ── Payment Declined ──────────────────────────────────────────────────────
  static const paymentDeclined = 'PAYMENT DECLINED';
  static const identityNotVerified = 'Identity not verified';
  static const errBioMismatch = 'ERR_BIO_MISMATCH';
  static const faceContourFailed = 'Facial contour did not reach the 85% minimum '
      'confidence threshold required for Fayda biometric authorization.';
  static const nationalFaydaId = 'National Fayda ID';
  static const cameraConfidence = 'Camera Confidence';
  static const minConfidence = 'Min. 85%';
  static const recommendedNextStep = 'Recommended Next Step';
  static const repositionCustomer =
      'Ask the customer to remove glasses or hat, ensure good lighting, '
      'and position face fully within the scan oval.';
  static const tryFaceScanAgain = 'Try face scan again';
  static const useOtpFallback = 'Use OTP fallback';

  // ── Payment Processing ────────────────────────────────────────────────────
  static const paymentInProgress = 'Payment in progress';
  static const biometricInstantAuth = 'Biometric instant authorization';
  static const verifyingIdentity = 'Verifying identity';
  static const twoFactorConfirmed = 'Two-factor credentials confirmed';
  static const checkingBalance = 'Checking balance';
  static const queryingLiquidity = 'Querying linked settlement liquidity';
  static const completingPayment = 'Completing payment';
  static const awaitingClearance = 'Awaiting ledger clearance';
  static const inProgressLabel = 'In Progress';
  static const pendingLabel = 'Pending';
  static const tlsSecured = '256-bit TLS encrypted transaction \u2022 Secured';
  static const settlementDisclaimer =
      'Average settlement time: 1.8s \u2022 Direct Telebirr / CBE rail. '
      'Please do not close or refresh this application.';

  // ── Payment Success ───────────────────────────────────────────────────────
  static const settledVerified = 'Settled & Verified';
  static const paymentSuccessful = 'Payment successful';
  static const paymentDetails = 'Payment details';
  static const instantSettlement = 'Instant settlement';
  static const biometricVerified = 'Biometric verified';
  static const paymentRailLabel = 'Payment rail';
  static const terminalLabel = 'Terminal';
  static const transactionRef = 'Transaction ref';
  static const zeroDisputeGuarantee =
      'Zero dispute guarantee \u2022 Telebirr instant rail';
  static const newSale = 'New sale';
  static const sendReceipt = 'Send receipt';

  // ── Transactions ──────────────────────────────────────────────────────────
  static const transactionsTitle = 'Transactions';
  static const realtimeActivity = 'Real-time payment activity and settlement';
  static const utcLabel = 'UTC+3 (Addis Ababa)';
  static const todaySettledVolume = "TODAY'S SETTLED VOLUME";
  static const syncedLabel = 'Synced';
  static const autoClears = 'Auto-clears at 00:00';
  static const searchPlaceholder = 'Search by customer name or ref #';
  static const recentRecords = 'RECENT RECORDS';
  static const selectedReceipt = 'Selected Transaction Receipt';
  static const printReceiptBtn = 'Print Receipt';
  static const reportIssue = 'Report Issue';
  static const directBoleHub = 'Direct Bole Hub Gateway';
  static const dailyStatement = 'Daily statement download';
  static const paidLabel = 'Paid';
  static const declinedLabel = 'Declined';
  static const todayFilter = 'Today';
  static const thisWeekFilter = 'This week';
  static const thisMonthFilter = 'This month';

  // ── Settings ─────────────────────────────────────────────────────────────
  static const settingsTitle = 'Settings';
  static const activePOS = 'Active POS';
  static const settlementRailsSection = 'SETTLEMENT & RAILS';
  static const realTimeRTGS = 'Real-time RTGS';
  static const payoutAccount = 'Payout Account Default';
  static const payoutAccountSub = 'Telebirr \u2022\u2022\u2022 8821';
  static const connectedBanks = 'Connected Banks';
  static const connectedBanksSub = 'CBE, Awash, Dashen \u2022 3 rails linked';
  static const transactionLimit = 'Transaction Limit';
  static const transactionLimitSub = '50,000 ETB / txn \u2022 Tier 2 clearance';
  static const terminalPreferencesSection = 'TERMINAL PREFERENCES';
  static const languageLabel = 'Language';
  static const languageSub = 'Active terminal language';
  static const audioAnnouncement = 'Audio Announcement';
  static const audioAnnouncementSub = 'Vocal confirmation on settled payment';
  static const autoPromptReceipt = 'Auto-Prompt Receipt';
  static const autoPromptReceiptSub = 'SMS or QR download after sale';
  static const supportDeviceSection = 'SUPPORT & DEVICE TRUST';
  static const helpMerchantSupport = 'Help & Merchant Support';
  static const helpMerchantSupportSub = 'Toll-Free 8821 \u2022 24/7 Desk';
  static const callNow = 'Call Now';
  static const securityEncryption = 'Security & Encryption';
  static const securityEncryptionSub = 'Hardware Key Active';
  static const securityVerified = '\u2713 Verified';
  static const yetmpayPOSCore = 'YETMpay POS Core';
  static const posCoreSub = 'Build v3.8.4-rel (Up to date) \u2022 SHA-a9f2c1';
  static const posCoreVersion = 'v3.8.4';
  static const logOutTerminal = 'Log out from terminal';
  static const logoutCaption =
      'Logging out terminates the active session on this POS terminal.';
  static const langEnglish = 'English';
  static const langAmharic = '\u12a0\u121b\u122d\u129b';
}


