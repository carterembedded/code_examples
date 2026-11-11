<?php

$post_id = $block->context['postId'] ?? 0;

if (!$post_id) {
    return '';
}

$begin = get_post_meta($post_id, 'event_begin', true);
$finish = get_post_meta($post_id, 'event_end', true);

if (!$begin || !$finish) {
    return '';
}

$start = new \DateTime($begin);
$end = new \DateTime($finish);

if ($start->format('Y-m-d') === $end->format('Y-m-d')) {
    $output = $start->format('j F Y') . ' | ';
    $output .= $start->format('H:i') . ' - ' . $end->format('H:i');
} else {
    $output = $start->format('j F Y H:i');
    $output .= ' - ' . $end->format('j F Y H:i');
}

$post_id = $block->context['postId'] ?? 'NO POST ID';

echo '<span class="event-datetime">' . esc_html($output) . '</span>';
