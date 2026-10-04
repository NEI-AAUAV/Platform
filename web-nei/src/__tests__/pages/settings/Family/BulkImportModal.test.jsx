import { describe, it, expect, vi, beforeEach } from "vitest";
import React from "react";
import { render, screen, waitFor, within } from "@testing-library/react";
import userEvent from "@testing-library/user-event";

const svc = vi.hoisted(() => ({
  bulkCreateUsers: vi.fn(),
  assignRole: vi.fn(),
  updateUserImage: vi.fn(),
}));
vi.mock("../../../../services/FamilyService", () => ({ default: svc }));
vi.mock("../../../../pages/Family/data", () => ({ colors: ["#111", "#222", "#333"] }));
vi.mock("../../../../components/ui/use-toast", () => ({
  useToast: () => ({ toast: vi.fn() }),
}));
vi.mock("../../../../components/Family", () => ({
  PatraoPicker: ({ onSelect }) => (
    <button
      type="button"
      onClick={() => onSelect({ id: 99, name: "Picked Patrao", start_year: 10, sex: "M" })}
    >
      pick-patrao
    </button>
  ),
  RolePickerModal: ({ isOpen, onSelect }) =>
    isOpen ? (
      <button type="button" onClick={() => onSelect({ id: ".1.2.", name: "Mestre" }, 21)}>
        pick-role
      </button>
    ) : null,
}));

const { default: BulkImportModal } = await import(
  "../../../../pages/settings/Family/BulkImportModal"
);

const ALL_USERS = [
  { id: 1, name: "Ana Silva", nmec: 1001, start_year: 18, sex: "F" },
  { id: 2, name: "Bruno Costa", nmec: 1002, start_year: 19, sex: "M" },
  { id: 3, name: "Rui Pinto", nmec: 1003, start_year: 19, sex: "M" },
  { id: 4, name: "Rui Pinto", nmec: 1004, start_year: 20, sex: "M" },
];

const HEADER = "name,sex,start_year,nmec,faina_name,patrao";

function setup(props = {}) {
  const onClose = vi.fn();
  const onComplete = vi.fn();
  const utils = render(
    <BulkImportModal isOpen onClose={onClose} onComplete={onComplete} allUsers={ALL_USERS} {...props} />
  );
  return { onClose, onComplete, ...utils };
}

async function upload(csv, name = "members.csv") {
  const input = document.body.querySelector('input[type="file"]');
  await userEvent.upload(input, new File([csv], name, { type: "text/csv" }));
}

const rowOf = (name) => screen.getByText(name).closest("tr");

beforeEach(() => {
  Object.values(svc).forEach((fn) => fn.mockReset());
  vi.spyOn(console, "error").mockImplementation(() => {});
});

describe("BulkImportModal - upload", () => {
  it("starts on the upload step", () => {
    setup();

    expect(screen.getByText("Importação de Membros")).toBeInTheDocument();
    expect(screen.getByRole("button", { name: /preencher manualmente/i })).toBeInTheDocument();
  });

  it("renders nothing when closed", () => {
    setup({ isOpen: false });

    expect(screen.queryByText("Importar Membros")).not.toBeInTheDocument();
  });

  it("parses a valid CSV into the preview table", async () => {
    setup();

    await upload(`${HEADER}\nJoao Silva,M,24,111,Silvinha,\nMaria Dias,F,23,,,\n`);

    expect(await screen.findByText("Joao Silva")).toBeInTheDocument();
    expect(screen.getByText("Maria Dias")).toBeInTheDocument();
    expect(screen.getByText("validos").parentElement).toHaveTextContent("2 validos");
    expect(screen.getByRole("button", { name: /importar 2 membro/i })).toBeEnabled();
  });

  it("accepts upper-case/spaced headers and lower-case sex", async () => {
    setup();

    await upload("Name , SEX ,Start_Year\nJoao Silva,m,24\n");

    expect(await screen.findByText("Joao Silva")).toBeInTheDocument();
    expect(rowOf("Joao Silva")).toHaveTextContent("M"); // normalised to upper case
  });

  it("lists every missing required column", async () => {
    setup();

    await upload("name,nmec\nJoao,1\n");

    expect(
      await screen.findByText("Colunas obrigatorias em falta: sex, start_year")
    ).toBeInTheDocument();
    expect(screen.queryByText(/validos/)).not.toBeInTheDocument();
  });

  it("rejects an empty file", async () => {
    setup();

    await upload(`${HEADER}\n`);

    expect(await screen.findByText("Ficheiro vazio")).toBeInTheDocument();
  });

  it("flags rows with missing name, bad sex or bad year as 'a corrigir'", async () => {
    setup();

    await upload(
      `${HEADER}\n,M,24,,,\nOk Person,M,24,,,\nBad Sex,X,24,,,\nBad Year,F,abc,,,\n`
    );

    expect(await screen.findByText("Ok Person")).toBeInTheDocument();
    expect(screen.getByText("a corrigir").parentElement).toHaveTextContent("3 a corrigir");
    expect(screen.getByText("validos").parentElement).toHaveTextContent("1 validos");
    expect(rowOf("Bad Sex").querySelector("[data-tip]")).toHaveAttribute("data-tip", "sexo invalido");
    expect(rowOf("Bad Year").querySelector("[data-tip]")).toHaveAttribute("data-tip", "ano invalido");
  });

  it("skips fully empty rows", async () => {
    setup();

    await upload(`${HEADER}\nAna Nova,F,24,,,\n,,,,,\n`);

    expect(await screen.findByText("Ana Nova")).toBeInTheDocument();
    expect(screen.getByText("validos").parentElement).toHaveTextContent("1 validos");
  });

  it("starts a manual entry with one blank row that still needs a name", async () => {
    setup();

    await userEvent.click(screen.getByRole("button", { name: /preencher manualmente/i }));

    expect(await screen.findByText(/a corrigir/)).toBeInTheDocument();
    expect(screen.getByRole("button", { name: /importar 0 membro/i })).toBeDisabled();
  });

  it("downloads a template with the selected optional columns", async () => {
    const blobs = [];
    vi.spyOn(URL, "createObjectURL").mockImplementation((blob) => {
      blobs.push(blob);
      return "blob:x";
    });
    vi.spyOn(URL, "revokeObjectURL").mockImplementation(() => {});
    vi.spyOn(HTMLAnchorElement.prototype, "click").mockImplementation(() => {});
    setup();

    await userEvent.click(screen.getByLabelText("Nome de Faina"));
    await userEvent.click(screen.getByLabelText("Nmec")); // untick
    await userEvent.click(screen.getByRole("button", { name: /descarregar modelo/i }));

    const bytes = new Uint8Array(
      await new Promise((resolve) => {
        const reader = new FileReader();
        reader.onload = () => resolve(reader.result);
        reader.readAsArrayBuffer(blobs[0]);
      })
    );
    // UTF-8 BOM so Excel opens accents correctly
    expect([...bytes.slice(0, 3)]).toEqual([0xef, 0xbb, 0xbf]);
    const header = new TextDecoder().decode(bytes.slice(3)).split("\n")[0];
    expect(header).toBe("name,sex,start_year,faina_name,patrao");
  });

  it("helps find a patrão by name, nmec or id", async () => {
    setup();
    const search = screen.getByPlaceholderText(/pesquisar por nome ou nmec/i);

    await userEvent.type(search, "bruno");
    expect(screen.getByText("Bruno Costa")).toBeInTheDocument();
    expect(screen.queryByText("Ana Silva")).not.toBeInTheDocument();

    await userEvent.clear(search);
    await userEvent.type(search, "1001");
    expect(screen.getByText("Ana Silva")).toBeInTheDocument();

    await userEvent.clear(search);
    await userEvent.type(search, "zzz");
    expect(screen.getByText(/nenhum membro encontrado/i)).toBeInTheDocument();
  });
});

describe("BulkImportModal - patrão resolution", () => {
  const patraoOf = async (value) => {
    setup();
    await upload(`${HEADER}\nNew Kid,M,24,,,${value}\n`);
    await screen.findByText("New Kid");
    return rowOf("New Kid");
  };

  it("resolves by nmec", async () => {
    expect(await patraoOf("1002")).toHaveTextContent("Bruno Costa");
  });

  it("resolves by internal id when no nmec matches", async () => {
    expect(await patraoOf("1")).toHaveTextContent("Ana Silva");
  });

  it("resolves by exact (case-insensitive) name", async () => {
    expect(await patraoOf("ana silva")).toHaveTextContent("Ana Silva");
  });

  it("resolves by a unique partial name", async () => {
    expect(await patraoOf("Bruno")).toHaveTextContent("Bruno Costa");
  });

  it("asks the user to choose when the name is ambiguous", async () => {
    const row = await patraoOf("Rui Pinto");

    expect(within(row).getByRole("button", { name: "Escolher" })).toBeInTheDocument();
    expect(row.querySelector("[data-tip]")).toHaveAttribute("data-tip", "Patrao ambiguo");
    expect(screen.getByRole("button", { name: /importar 0 membro/i })).toBeDisabled();
  });

  it("blocks the import when the patrão does not exist", async () => {
    const row = await patraoOf("Nobody Atall");

    expect(row.querySelector("[data-tip]")).toHaveAttribute("data-tip", "Patrao nao encontrado");
    expect(screen.getByRole("button", { name: /importar 0 membro/i })).toBeDisabled();
  });

  it("lets the user fix an unresolved patrão with the picker", async () => {
    const row = await patraoOf("Nobody Atall");

    await userEvent.click(within(row).getByRole("button", { name: "Escolher" }));
    await userEvent.click(await screen.findByRole("button", { name: "pick-patrao" }));

    await waitFor(() => expect(rowOf("New Kid")).toHaveTextContent("Picked Patrao"));
    expect(screen.getByRole("button", { name: /importar 1 membro/i })).toBeEnabled();
  });

  it("an empty patrão cell is valid (root member)", async () => {
    const row = await patraoOf("");

    expect(row.querySelector("[data-tip]")).toBeNull();
  });
});

describe("BulkImportModal - editing", () => {
  it("removes a row", async () => {
    setup();
    await upload(`${HEADER}\nAna Nova,F,24,,,\nBia Nova,F,24,,,\n`);
    await screen.findByText("Ana Nova");

    await userEvent.click(within(rowOf("Ana Nova")).getByTitle("Remover"));

    expect(screen.queryByText("Ana Nova")).not.toBeInTheDocument();
    expect(screen.getByText("Bia Nova")).toBeInTheDocument();
  });

  it("edits a cell inline and revalidates the row", async () => {
    setup();
    await upload(`${HEADER}\n,M,24,,,\n`);
    await screen.findByText(/a corrigir/);

    // the name cell of the single row
    const nameCell = document.querySelectorAll("tbody td")[1];
    await userEvent.click(nameCell);
    await userEvent.type(document.querySelector("tbody input"), "Fixed Name{Enter}");

    expect(await screen.findByText("Fixed Name")).toBeInTheDocument();
    expect(screen.getByText("validos").parentElement).toHaveTextContent("1 validos");
  });

  it("adds a blank row manually", async () => {
    setup();
    await upload(`${HEADER}\nAna Nova,F,24,,,\n`);
    await screen.findByText("Ana Nova");

    await userEvent.click(screen.getByRole("button", { name: /adicionar linha/i }));

    expect(document.querySelectorAll("tbody tr")).toHaveLength(2);
  });

  it("goes back to the upload step and clears the preview", async () => {
    setup();
    await upload(`${HEADER}\nAna Nova,F,24,,,\n`);
    await screen.findByText("Ana Nova");

    await userEvent.click(screen.getAllByRole("button", { name: /voltar/i })[0]);

    expect(screen.getByText("Importação de Membros")).toBeInTheDocument();
    expect(screen.queryByText("Ana Nova")).not.toBeInTheDocument();
  });
});

describe("BulkImportModal - submit", () => {
  const created = [
    { id: 10, name: "Ana Nova", sex: "F", start_year: 24, patrao_id: 2, nmec: null },
    { id: 11, name: "Bia Nova", sex: "F", start_year: 24, patrao_id: null, nmec: null },
  ];

  it("sends only valid rows with the API field names and moves on to photos", async () => {
    svc.bulkCreateUsers.mockResolvedValue({
      created, errors: [], warnings: [], total_submitted: 2, total_created: 2, total_errors: 0,
    });
    const { onComplete } = setup();
    await upload(
      `${HEADER}\nAna Nova,F,24,555,Anita,1002\nBia Nova,F,24,,,\nInvalid Sex,Z,24,,,\n`
    );
    await screen.findByText("Ana Nova");

    await userEvent.click(screen.getByRole("button", { name: /importar 2 membro/i }));

    await waitFor(() => expect(svc.bulkCreateUsers).toHaveBeenCalledTimes(1));
    expect(svc.bulkCreateUsers).toHaveBeenCalledWith([
      { name: "Ana Nova", sex: "F", start_year: 24, nmec: 555, faina_name: "Anita", patrao_id: 2, course_id: null },
      { name: "Bia Nova", sex: "F", start_year: 24, nmec: null, faina_name: null, patrao_id: null, course_id: null },
    ]);
    expect(await screen.findByText("Carregar Fotos")).toBeInTheDocument();
    expect(onComplete).toHaveBeenCalledTimes(1);
  });

  it("shows the failure summary when the server creates nobody", async () => {
    svc.bulkCreateUsers.mockResolvedValue({
      created: [],
      errors: [{ row: 0, message: "Patrão com id 7 não encontrado", data: { name: "Ana Nova" } }],
      warnings: ["Nome duplicado"],
      total_submitted: 1, total_created: 0, total_errors: 1,
    });
    setup();
    await upload(`${HEADER}\nAna Nova,F,24,,,\n`);
    await screen.findByText("Ana Nova");

    await userEvent.click(screen.getByRole("button", { name: /importar 1 membro/i }));

    expect(await screen.findByText("Importação Falhou")).toBeInTheDocument();
    expect(screen.getByText("Patrão com id 7 não encontrado")).toBeInTheDocument();
    expect(screen.getByText("1 aviso(s)")).toBeInTheDocument();
    expect(screen.getByText("1 erro(s)")).toBeInTheDocument();
  });

  it("reports a network/server failure as a result instead of crashing", async () => {
    svc.bulkCreateUsers.mockRejectedValue({ response: { data: { detail: "Máximo de 100 utilizadores" } } });
    setup();
    await upload(`${HEADER}\nAna Nova,F,24,,,\n`);
    await screen.findByText("Ana Nova");

    await userEvent.click(screen.getByRole("button", { name: /importar 1 membro/i }));

    expect(await screen.findByText("Importação Falhou")).toBeInTheDocument();
    expect(screen.getByText("Máximo de 100 utilizadores")).toBeInTheDocument();
  });

  it("walks through photos and roles to the final summary", async () => {
    svc.bulkCreateUsers.mockResolvedValue({
      created, errors: [], warnings: [], total_submitted: 2, total_created: 2, total_errors: 0,
    });
    svc.assignRole.mockResolvedValue({});
    setup();
    await upload(`${HEADER}\nAna Nova,F,24,,,\nBia Nova,F,24,,,\n`);
    await screen.findByText("Ana Nova");
    await userEvent.click(screen.getByRole("button", { name: /importar 2 membro/i }));

    // photos -> skip -> roles
    await userEvent.click(await screen.findByRole("button", { name: "Saltar" }));
    expect(await screen.findByText("2 membro(s) criado(s)!")).toBeInTheDocument();

    // add a role to the first created member
    await userEvent.click(screen.getAllByRole("button", { name: /insignia/i })[0]);
    await userEvent.click(await screen.findByRole("button", { name: "pick-role" }));
    expect(await screen.findByText("Mestre (21)")).toBeInTheDocument();
    await userEvent.click(screen.getByRole("button", { name: /atribuir 1 insignia/i }));

    await waitFor(() =>
      expect(svc.assignRole).toHaveBeenCalledWith({ user_id: 10, role_id: ".1.2.", year: 21 })
    );
    expect(await screen.findByText("Importação Concluída")).toBeInTheDocument();
    expect(screen.getByText("1 insignia(s) atribuida(s)")).toBeInTheDocument();
    expect(screen.getByText("Criou 2 membro(s)")).toBeInTheDocument();
  });

  it("a role can be removed again before assigning (no crash)", async () => {
    svc.bulkCreateUsers.mockResolvedValue({
      created, errors: [], warnings: [], total_submitted: 2, total_created: 2, total_errors: 0,
    });
    setup();
    await upload(`${HEADER}\nAna Nova,F,24,,,\n`);
    await screen.findByText("Ana Nova");
    await userEvent.click(screen.getByRole("button", { name: /importar 1 membro/i }));
    await userEvent.click(await screen.findByRole("button", { name: "Saltar" }));
    await userEvent.click(screen.getAllByRole("button", { name: /insignia/i })[0]);
    await userEvent.click(await screen.findByRole("button", { name: "pick-role" }));

    const chip = (await screen.findByText("Mestre (21)")).closest("span");
    await userEvent.click(within(chip).getByRole("button"));

    expect(screen.queryByText("Mestre (21)")).not.toBeInTheDocument();
    expect(screen.getByRole("button", { name: /atribuir 0 insignia/i })).toBeDisabled();
  });

  it("uploads selected photos and reports how many succeeded", async () => {
    svc.bulkCreateUsers.mockResolvedValue({
      created, errors: [], warnings: [], total_submitted: 2, total_created: 2, total_errors: 0,
    });
    svc.updateUserImage.mockResolvedValue({ image: "https://cdn/x.jpg" });
    vi.spyOn(URL, "createObjectURL").mockReturnValue("blob:preview");
    vi.spyOn(URL, "revokeObjectURL").mockImplementation(() => {});
    setup();
    await upload(`${HEADER}\nAna Nova,F,24,,,\n`);
    await screen.findByText("Ana Nova");
    await userEvent.click(screen.getByRole("button", { name: /importar 1 membro/i }));
    await screen.findByText("Carregar Fotos");

    const photoInput = document.body.querySelector('input[type="file"][accept*="image"]');
    const file = new File(["img"], "a.png", { type: "image/png" });
    await userEvent.upload(photoInput, file);
    await userEvent.click(screen.getByRole("button", { name: /guardar e continuar/i }));

    await waitFor(() => expect(svc.updateUserImage).toHaveBeenCalledWith(10, file));
    expect(await screen.findByText("2 membro(s) criado(s)!")).toBeInTheDocument();
  });
});
