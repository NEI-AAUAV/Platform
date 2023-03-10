export default function Spinner({ className }) {
	return (
		<div role="status" className={className}>
			<svg aria-hidden="true" className="text-primary" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
				<circle className="innerCircle" cx="50%" cy="50%" r="50%" fill="none" stroke="currentColor" strokeWidth="5%">
					<animate attributeType="SVG" attributeName="r" begin="0s" dur="4s" repeatCount="indefinite" from="5%" to="50%" />
					<animate attributeType="CSS" attributeName="stroke-width" begin="0s" dur="4s" repeatCount="indefinite" from="3%" to="0%" />
					<animate attributeType="CSS" attributeName="opacity" begin="0s" dur="4s" repeatCount="indefinite" from="1" to="0" />
				</circle>
			</svg>
			<span className="sr-only">Loading...</span>
		</div>
	);
};
