(function (blocks, element, blockEditor) {
    const el = element.createElement;

    blocks.registerBlockType('carter/event-datetime', {
        edit: function () {
            return el(
                'div',
                blockEditor.useBlockProps(),
                'Event Date & Time (preview on frontend)'
            );
        },

        save: function () {
            return null;
        }
    });
})(
    window.wp.blocks,
    window.wp.element,
    window.wp.blockEditor
);