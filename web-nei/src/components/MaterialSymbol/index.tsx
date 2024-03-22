import { cn } from "lib/utils";
import {
  MaterialSymbol as GoogleMaterialSymbol,
  MaterialSymbolProps,
} from "react-material-symbols";

type ParentDivProps = {
  parentDivClassName?: string;
};

/**
 * # Google's Material Symbols, tailored for NEI
 *
 * NEI's Material Symbols guidelines are stated as follows:
 * - Weight: 500
 * - Grade: 0
 * - Fill: `true`
 * - Optical size: 24px
 *
 * Instead of defining these properties each time a Material Symbol is used, this
 * component reduces time and improves consistency since coding is error-prone.
 * One can still change some properties - such as size and fill - although it's
 * not recommended.
 *
 * Most of the time, one should only need `<MaterialSymbol icon="something" />`.
 *
 * A complete list of icons is available at https://fonts.google.com/icons and
 * https://react-material-symbols.vercel.app/?path=/docs/rounded--example.
 */
export default function MaterialSymbol({
  parentDivClassName,
  ...props
}: MaterialSymbolProps & ParentDivProps) {
  return (
    <div className={cn("flex", parentDivClassName)}>
      <GoogleMaterialSymbol
        weight={props.weight ?? 500}
        size={props.size ?? 24}
        fill={props.fill ?? true}
        grade={props.grade ?? 0}
        {...props}
      />
    </div>
  );
}
