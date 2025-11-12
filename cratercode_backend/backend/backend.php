<?php
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

function handleListCourses(mysqli $mysqli): void
{
    $coursesResult = $mysqli->query('SELECT id, slug, name, duration_weeks, difficulty_level, category, delivery_mode, technology_stack, summary FROM courses ORDER BY id DESC');

    if (!$coursesResult) {
        sendResponse(500, ['success' => false, 'message' => 'Failed to load courses.'], $mysqli);
    }

    $courses = [];
    $courseIds = [];

    while ($row = $coursesResult->fetch_assoc()) {
        $normalized = normalizeCourseRow($row);
        $courses[$normalized['id']] = $normalized;
        $courseIds[] = $normalized['id'];
    }

    $coursesResult->free();

    if (!empty($courseIds)) {
        $idList = implode(',', array_map('intval', $courseIds));
        $detailsQuery = "SELECT id, course_id, tech_name, headline, tech_stacks, long_description, display_order FROM course_technology_details WHERE course_id IN ($idList) ORDER BY course_id, display_order, id";
        $detailsResult = $mysqli->query($detailsQuery);

        if ($detailsResult) {
            while ($detailRow = $detailsResult->fetch_assoc()) {
                $courseId = (int)$detailRow['course_id'];
                if (!isset($courses[$courseId])) {
                    continue;
                }
                $courses[$courseId]['details'][] = normalizeDetailRow($detailRow);
            }
            $detailsResult->free();
        }
    }

    sendResponse(200, ['success' => true, 'data' => array_values($courses)], $mysqli);
}

function handleCreateCourse(mysqli $mysqli, array $data): void
{
    $name = trim((string)($data['name'] ?? $data['title'] ?? ''));
    $summary = trim((string)($data['summary'] ?? $data['description'] ?? ''));
    $category = trim((string)($data['category'] ?? ''));
    $difficulty = trim((string)($data['difficulty_level'] ?? $data['difficultyLevel'] ?? 'All Levels'));
    $deliveryMode = trim((string)($data['delivery_mode'] ?? $data['deliveryMode'] ?? 'Hybrid'));
    $durationWeeks = (int)($data['duration_weeks'] ?? $data['durationWeeks'] ?? 0);

    $technologyStack = '';
    if (isset($data['technologies']) && is_array($data['technologies'])) {
        $technologyStack = implode(', ', array_filter(array_map(static fn($item) => trim((string)$item), $data['technologies'])));
    } elseif (isset($data['technology_stack'])) {
        $technologyStack = trim((string)$data['technology_stack']);
    }

    if ($name === '' || $summary === '' || $category === '' || $technologyStack === '') {
        sendResponse(422, ['success' => false, 'message' => 'Missing required fields for course creation.'], $mysqli);
    }

    if ($durationWeeks <= 0) {
        $durationWeeks = 1;
    }

    if ($difficulty === '') {
        $difficulty = 'All Levels';
    }

    if ($deliveryMode === '') {
        $deliveryMode = 'Hybrid';
    }

    $slugSource = trim((string)($data['slug'] ?? $name));
    $slug = generateSlug($slugSource);

    if ($slug === '') {
        sendResponse(422, ['success' => false, 'message' => 'Unable to generate course slug.'], $mysqli);
    }

    $stmt = $mysqli->prepare('INSERT INTO courses (slug, name, duration_weeks, difficulty_level, category, delivery_mode, technology_stack, summary) VALUES (?, ?, ?, ?, ?, ?, ?, ?)');

    if (!$stmt) {
        sendResponse(500, ['success' => false, 'message' => 'Failed to prepare course insert statement.'], $mysqli);
    }

    $stmt->bind_param('ssisssss', $slug, $name, $durationWeeks, $difficulty, $category, $deliveryMode, $technologyStack, $summary);

    if (!$stmt->execute()) {
        $stmt->close();
        sendResponse(500, ['success' => false, 'message' => 'Failed to create course.'], $mysqli);
    }

    $courseId = (int)$mysqli->insert_id;
    $stmt->close();

    $course = fetchCourseById($mysqli, $courseId);

    if ($course === null) {
        sendResponse(500, ['success' => false, 'message' => 'Course created but could not be reloaded.'], $mysqli);
    }

    sendResponse(200, ['success' => true, 'data' => $course], $mysqli);
}

function handleUpdateCourse(mysqli $mysqli, array $data): void
{
    $courseId = (int)($data['id'] ?? $data['course_id'] ?? 0);

    if ($courseId <= 0) {
        sendResponse(422, ['success' => false, 'message' => 'Course ID is required for update.'], $mysqli);
    }

    $name = trim((string)($data['name'] ?? $data['title'] ?? ''));
    $summary = trim((string)($data['summary'] ?? $data['description'] ?? ''));
    $category = trim((string)($data['category'] ?? ''));
    $difficulty = trim((string)($data['difficulty_level'] ?? $data['difficultyLevel'] ?? 'All Levels'));
    $deliveryMode = trim((string)($data['delivery_mode'] ?? $data['deliveryMode'] ?? 'Hybrid'));
    $durationWeeks = (int)($data['duration_weeks'] ?? $data['durationWeeks'] ?? 0);

    $technologyStack = '';
    if (isset($data['technologies']) && is_array($data['technologies'])) {
        $technologyStack = implode(', ', array_filter(array_map(static fn($item) => trim((string)$item), $data['technologies'])));
    } elseif (isset($data['technology_stack'])) {
        $technologyStack = trim((string)$data['technology_stack']);
    }

    if ($name === '' || $summary === '' || $category === '' || $technologyStack === '') {
        sendResponse(422, ['success' => false, 'message' => 'Missing required fields for course update.'], $mysqli);
    }

    if ($durationWeeks <= 0) {
        $durationWeeks = 1;
    }

    if ($difficulty === '') {
        $difficulty = 'All Levels';
    }

    if ($deliveryMode === '') {
        $deliveryMode = 'Hybrid';
    }

    $slugSource = trim((string)($data['slug'] ?? $name));
    $slug = generateSlug($slugSource);

    if ($slug === '') {
        sendResponse(422, ['success' => false, 'message' => 'Unable to generate course slug.'], $mysqli);
    }

    $stmt = $mysqli->prepare('UPDATE courses SET slug = ?, name = ?, duration_weeks = ?, difficulty_level = ?, category = ?, delivery_mode = ?, technology_stack = ?, summary = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?');

    if (!$stmt) {
        sendResponse(500, ['success' => false, 'message' => 'Failed to prepare course update statement.'], $mysqli);
    }

    $stmt->bind_param('ssisssssi', $slug, $name, $durationWeeks, $difficulty, $category, $deliveryMode, $technologyStack, $summary, $courseId);

    if (!$stmt->execute()) {
        $stmt->close();
        sendResponse(500, ['success' => false, 'message' => 'Failed to update course.'], $mysqli);
    }

    $stmt->close();

    $course = fetchCourseById($mysqli, $courseId);

    if ($course === null) {
        sendResponse(404, ['success' => false, 'message' => 'Course not found after update.'], $mysqli);
    }

    sendResponse(200, ['success' => true, 'data' => $course], $mysqli);
}

function handleDeleteCourse(mysqli $mysqli, array $data): void
{
    $courseId = (int)($data['id'] ?? $data['course_id'] ?? 0);

    if ($courseId <= 0) {
        sendResponse(422, ['success' => false, 'message' => 'Course ID is required for deletion.'], $mysqli);
    }

    $stmt = $mysqli->prepare('DELETE FROM courses WHERE id = ?');

    if (!$stmt) {
        sendResponse(500, ['success' => false, 'message' => 'Failed to prepare course deletion statement.'], $mysqli);
    }

    $stmt->bind_param('i', $courseId);

    if (!$stmt->execute()) {
        $stmt->close();
        sendResponse(500, ['success' => false, 'message' => 'Failed to delete course.'], $mysqli);
    }

    $affected = $stmt->affected_rows;
    $stmt->close();

    if ($affected === 0) {
        sendResponse(404, ['success' => false, 'message' => 'Course not found.'], $mysqli);
    }

    sendResponse(200, ['success' => true, 'message' => 'Course deleted successfully.'], $mysqli);
}

function handleUpsertCourseDetails(mysqli $mysqli, array $data): void
{
    $courseId = (int)($data['course_id'] ?? $data['id'] ?? 0);

    if ($courseId <= 0) {
        sendResponse(422, ['success' => false, 'message' => 'Course ID is required for detail updates.'], $mysqli);
    }

    $details = $data['details'] ?? [];

    if (!is_array($details)) {
        sendResponse(422, ['success' => false, 'message' => 'Details payload must be an array.'], $mysqli);
    }

    $mysqli->begin_transaction();

    try {
        $deleteStmt = $mysqli->prepare('DELETE FROM course_technology_details WHERE course_id = ?');

        if (!$deleteStmt) {
            throw new RuntimeException('Failed to prepare detail cleanup statement.');
        }

        $deleteStmt->bind_param('i', $courseId);
        $deleteStmt->execute();
        $deleteStmt->close();

        if (!empty($details)) {
            $insertStmt = $mysqli->prepare('INSERT INTO course_technology_details (course_id, tech_name, headline, tech_stacks, long_description, display_order) VALUES (?, ?, ?, ?, ?, ?)');

            if (!$insertStmt) {
                throw new RuntimeException('Failed to prepare detail insert statement.');
            }

            foreach ($details as $index => $detail) {
                if (!is_array($detail)) {
                    continue;
                }

                $techName = trim((string)($detail['tech_name'] ?? $detail['techName'] ?? $detail['techStack'] ?? ''));
                $headline = trim((string)($detail['headline'] ?? $techName));
                $techStacks = trim((string)($detail['tech_stacks'] ?? $detail['techStacks'] ?? $techName));
                $longDescription = trim((string)($detail['long_description'] ?? $detail['description'] ?? ''));
                $displayOrder = (int)($detail['display_order'] ?? $detail['displayOrder'] ?? ($index + 1));

                if ($techName === '' && $longDescription === '') {
                    continue;
                }

                if ($techName === '') {
                    $techName = 'Tech Stack ' . ($index + 1);
                }

                if ($longDescription === '') {
                    $longDescription = 'Details pending.';
                }

                $insertStmt->bind_param('issssi', $courseId, $techName, $headline, $techStacks, $longDescription, $displayOrder);
                $insertStmt->execute();
            }

            $insertStmt->close();
        }

        $mysqli->commit();
    } catch (Throwable $exception) {
        $mysqli->rollback();
        sendResponse(500, ['success' => false, 'message' => 'Failed to update course details.'], $mysqli);
    }

    $course = fetchCourseById($mysqli, $courseId);

    if ($course === null) {
        sendResponse(404, ['success' => false, 'message' => 'Course not found after updating details.'], $mysqli);
    }

    sendResponse(200, ['success' => true, 'data' => $course], $mysqli);
}

function fetchCourseById(mysqli $mysqli, int $courseId): ?array
{
    $stmt = $mysqli->prepare('SELECT id, slug, name, duration_weeks, difficulty_level, category, delivery_mode, technology_stack, summary FROM courses WHERE id = ? LIMIT 1');

    if (!$stmt) {
        return null;
    }

    $stmt->bind_param('i', $courseId);

    if (!$stmt->execute()) {
        $stmt->close();
        return null;
    }

    $result = $stmt->get_result();
    $courseRow = $result ? $result->fetch_assoc() : null;
    $stmt->close();

    if (!$courseRow) {
        return null;
    }

    $course = normalizeCourseRow($courseRow);
    $course['details'] = [];

    $detailsStmt = $mysqli->prepare('SELECT id, course_id, tech_name, headline, tech_stacks, long_description, display_order FROM course_technology_details WHERE course_id = ? ORDER BY display_order, id');

    if ($detailsStmt) {
        $detailsStmt->bind_param('i', $courseId);
        if ($detailsStmt->execute()) {
            $detailsResult = $detailsStmt->get_result();
            while ($detailRow = $detailsResult->fetch_assoc()) {
                $course['details'][] = normalizeDetailRow($detailRow);
            }
        }
        $detailsStmt->close();
    }

    return $course;
}

function normalizeCourseRow(array $row): array
{
    return [
        'id' => (int)$row['id'],
        'slug' => $row['slug'],
        'name' => $row['name'],
        'duration_weeks' => (int)$row['duration_weeks'],
        'difficulty_level' => $row['difficulty_level'],
        'category' => $row['category'],
        'delivery_mode' => $row['delivery_mode'],
        'technology_stack' => $row['technology_stack'],
        'summary' => $row['summary'],
        'details' => [],
    ];
}

function normalizeDetailRow(array $row): array
{
    return [
        'id' => (int)$row['id'],
        'course_id' => (int)$row['course_id'],
        'tech_name' => $row['tech_name'],
        'headline' => $row['headline'],
        'tech_stacks' => $row['tech_stacks'],
        'long_description' => $row['long_description'],
        'display_order' => (int)$row['display_order'],
    ];
}

function generateSlug(string $value): string
{
    $normalized = strtolower(trim($value));
    $normalized = preg_replace('/[^a-z0-9]+/i', '-', $normalized ?? '');
    $normalized = trim((string)$normalized, '-');
    return $normalized ?? '';
}

$input = file_get_contents('php://input');
$data = json_decode($input, true);

if (!is_array($data)) {
    sendResponse(400, ['success' => false, 'message' => 'Invalid JSON payload.']);
}

$action = isset($data['action']) ? trim((string)$data['action']) : 'submit_application';

$host = 'localhost';
$username = 'root';
$password = '';
$database = 'cratercode_applications';

$mysqli = new mysqli($host, $username, $password, $database);

if ($mysqli->connect_errno) {
    sendResponse(500, ['success' => false, 'message' => 'Database connection failed.']);
}

switch ($action) {
    case 'login':
        handleLogin($mysqli, $data);
        break;

    case 'submit_application':
    case '':
    case null:
        handleSubmitApplication($mysqli, $data);
        break;

    case 'list_courses':
        handleListCourses($mysqli);
        break;

    case 'create_course':
        handleCreateCourse($mysqli, $data);
        break;

    case 'update_course':
        handleUpdateCourse($mysqli, $data);
        break;

    case 'delete_course':
        handleDeleteCourse($mysqli, $data);
        break;

    case 'upsert_course_details':
        handleUpsertCourseDetails($mysqli, $data);
        break;

    default:
        sendResponse(400, ['success' => false, 'message' => 'Unknown action. Supported actions: submit_application, login, list_courses, create_course, update_course, delete_course, upsert_course_details.'], $mysqli);
}

function handleSubmitApplication(mysqli $mysqli, array $data): void
{
    $requiredFields = ['full_name', 'email', 'phone', 'course'];
    foreach ($requiredFields as $field) {
        if (empty($data[$field]) || !is_string($data[$field])) {
            sendResponse(422, ['success' => false, 'message' => "Missing required field: $field"], $mysqli);
        }
    }

    $fullName = trim($data['full_name']);
    $email = trim($data['email']);
    $phone = trim($data['phone']);
    $course = trim($data['course']);
    $message = isset($data['message']) && is_string($data['message']) ? trim($data['message']) : null;

    $stmt = $mysqli->prepare('INSERT INTO course_applications (full_name, email, phone, course, message) VALUES (?, ?, ?, ?, ?)');

    if (!$stmt) {
        sendResponse(500, ['success' => false, 'message' => 'Failed to prepare statement.'], $mysqli);
    }

    $stmt->bind_param('sssss', $fullName, $email, $phone, $course, $message);

    if ($stmt->execute()) {
        $stmt->close();
        sendResponse(200, ['success' => true, 'message' => 'Application received successfully.'], $mysqli);
    }

    $stmt->close();
    sendResponse(500, ['success' => false, 'message' => 'Failed to save application.'], $mysqli);
}

function handleLogin(mysqli $mysqli, array $data): void
{
    $identifier = isset($data['identifier']) && is_string($data['identifier']) ? trim($data['identifier']) : '';
    $username = isset($data['username']) && is_string($data['username']) ? trim($data['username']) : '';
    $email = isset($data['email']) && is_string($data['email']) ? trim($data['email']) : '';
    $password = isset($data['password']) && is_string($data['password']) ? $data['password'] : '';

    if ($identifier === '' && $username === '' && $email === '') {
        sendResponse(422, ['success' => false, 'message' => 'Username or email is required.'], $mysqli);
    }

    if ($password === '') {
        sendResponse(422, ['success' => false, 'message' => 'Password is required.'], $mysqli);
    }

    $lookupValue = $identifier !== '' ? $identifier : ($username !== '' ? $username : $email);

    $stmt = $mysqli->prepare('SELECT id, username, email, password_hash, full_name, is_active, last_login FROM users WHERE username = ? OR email = ? LIMIT 1');

    if (!$stmt) {
        sendResponse(500, ['success' => false, 'message' => 'Failed to prepare user lookup.'], $mysqli);
    }

    $stmt->bind_param('ss', $lookupValue, $lookupValue);

    if (!$stmt->execute()) {
        $stmt->close();
        sendResponse(500, ['success' => false, 'message' => 'Failed to execute user lookup.'], $mysqli);
    }

    $result = $stmt->get_result();

    if (!$result || $result->num_rows === 0) {
        $stmt->close();
        sendResponse(401, ['success' => false, 'message' => 'Invalid credentials.'], $mysqli);
    }

    $user = $result->fetch_assoc();
    $stmt->close();

    if ((int)$user['is_active'] !== 1) {
        sendResponse(403, ['success' => false, 'message' => 'Account is inactive. Please contact support.'], $mysqli);
    }

    if (!password_verify($password, $user['password_hash'])) {
        sendResponse(401, ['success' => false, 'message' => 'Invalid credentials.'], $mysqli);
    }

    $updateStmt = $mysqli->prepare('UPDATE users SET last_login = NOW() WHERE id = ?');
    if ($updateStmt) {
        $userId = (int)$user['id'];
        $updateStmt->bind_param('i', $userId);
        $updateStmt->execute();
        $updateStmt->close();
    }

    $userData = [
        'id' => (int)$user['id'],
        'username' => $user['username'],
        'email' => $user['email'],
        'full_name' => $user['full_name'],
        'is_active' => (bool)$user['is_active'],
        'last_login' => $user['last_login'] ?? null,
    ];

    sendResponse(200, ['success' => true, 'message' => 'Login successful.', 'data' => $userData], $mysqli);
}

function sendResponse(int $statusCode, array $payload, ?mysqli $mysqli = null): void
{
    if ($mysqli instanceof mysqli) {
        $mysqli->close();
    }

    http_response_code($statusCode);
    echo json_encode($payload);
    exit;
}